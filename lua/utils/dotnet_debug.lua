local M = {}

local DEFAULT_PROFILE_NAME = "Default (no launch profile)"

---@class DotnetLaunchProfile
---@field name string
---@field commandName? string
---@field commandLineArgs? string
---@field workingDirectory? string
---@field applicationUrl? string
---@field environmentVariables? table<string, string>

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = ".NET debugger" })
end

---@param value string
---@return string[]
local function parse_command_line(value)
  local args, current, quote, escaped, started = {}, {}, nil, false, false

  local function push()
    if started then
      args[#args + 1] = table.concat(current)
      current = {}
      started = false
    end
  end

  for i = 1, #value do
    local char = value:sub(i, i)
    if escaped then
      current[#current + 1] = char
      escaped = false
      started = true
    elseif char == "\\" and quote ~= "'" then
      local next_char = value:sub(i + 1, i + 1)
      if next_char == "\\" or next_char == '"' or (quote == nil and next_char:match("%s")) then
        escaped = true
        started = true
      else
        current[#current + 1] = char
        started = true
      end
    elseif quote then
      if char == quote then
        quote = nil
      else
        current[#current + 1] = char
      end
    elseif char == "'" or char == '"' then
      quote = char
      started = true
    elseif char:match("%s") then
      push()
    else
      current[#current + 1] = char
      started = true
    end
  end

  if escaped then
    current[#current + 1] = "\\"
  end
  push()
  return args
end

---@param settings table?
---@return DotnetLaunchProfile[]
local function profiles_from_settings(settings)
  local profiles = {}
  local configured = type(settings) == "table" and settings.profiles or nil

  if type(configured) == "table" then
    for name, profile in pairs(configured) do
      if type(name) == "string" and type(profile) == "table" and profile.commandName == "Project" then
        local copy = vim.deepcopy(profile)
        copy.name = name
        profiles[#profiles + 1] = copy
      end
    end
  end

  table.sort(profiles, function(a, b)
    return a.name < b.name
  end)

  if #profiles == 0 then
    profiles[1] = { name = DEFAULT_PROFILE_NAME, commandName = "Project" }
  end
  return profiles
end

---@param path string
---@return boolean
local function is_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

---@param path string
---@return boolean
local function is_absolute(path)
  if vim.fn.has("win32") == 1 then
    return path:match("^%a:[/\\]") ~= nil or path:match("^[/\\][/\\]") ~= nil
  end
  return path:sub(1, 1) == "/"
end

---@param path string
---@return table?
local function read_json(path)
  if not is_file(path) then
    return nil
  end

  local ok, result = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
  if not ok then
    notify(("Could not parse %s:\n%s"):format(path, result), vim.log.levels.ERROR)
    return nil
  end
  return result
end

---@param path string
---@return boolean
local function is_project(path)
  return path:sub(-7):lower() == ".csproj"
end

---@return string, string[]
local function find_projects()
  local buffer_path = vim.api.nvim_buf_get_name(0)
  local start = buffer_path ~= "" and vim.fs.dirname(buffer_path) or vim.fn.getcwd()
  local nearest = vim.fs.find(is_project, { path = start, upward = true, type = "file", limit = 1 })[1]
  local selected_solution = vim.g.roslyn_nvim_selected_solution
  local root

  if type(selected_solution) == "string" and selected_solution ~= "" then
    root = vim.fs.dirname(selected_solution)
  else
    local solution = vim.fs.find(function(name)
      return name:match("%.slnx?$") ~= nil
    end, { path = start, upward = true, type = "file", limit = 1 })[1]
    root = solution and vim.fs.dirname(solution) or vim.fs.root(start, ".git") or vim.fn.getcwd()
  end

  local projects = vim.fs.find(is_project, { path = root, type = "file", limit = math.huge })
  table.sort(projects, function(a, b)
    if a == nearest then
      return true
    elseif b == nearest then
      return false
    end
    return a < b
  end)

  return root, projects
end

---@param project string
---@return DotnetLaunchProfile[]
local function get_profiles(project)
  local path = vim.fs.joinpath(vim.fs.dirname(project), "Properties", "launchSettings.json")
  return profiles_from_settings(read_json(path))
end

---@param command string[]
---@param callback fun(result: vim.SystemCompleted)
local function run(command, callback)
  vim.system(command, { text = true }, vim.schedule_wrap(callback))
end

---@param output string
---@return table?
local function decode_msbuild(output)
  local json_start = output:find("{", 1, true)
  if not json_start then
    return nil
  end
  local ok, result = pcall(vim.json.decode, output:sub(json_start))
  return ok and result.Properties or nil
end

---@param project string
---@param callback fun(frameworks: string[]?)
local function get_frameworks(project, callback)
  run({
    "dotnet",
    "msbuild",
    project,
    "-nologo",
    "-getProperty:TargetFramework,TargetFrameworks",
    "-property:Configuration=Debug",
  }, function(result)
    local properties = result.code == 0 and decode_msbuild(result.stdout) or nil
    if not properties then
      notify("Could not evaluate the project's target framework.\n" .. (result.stderr or ""), vim.log.levels.ERROR)
      return
    end

    local value = properties.TargetFrameworks ~= "" and properties.TargetFrameworks or properties.TargetFramework
    if type(value) ~= "string" or value == "" then
      notify("The selected project does not define a target framework.", vim.log.levels.ERROR)
      return
    end
    callback(vim.split(value, ";", { plain = true, trimempty = true }))
  end)
end

---@param project string
---@param framework string?
---@param callback fun(target_path: string?)
local function build(project, framework, callback)
  local command = { "dotnet", "build", project, "--configuration", "Debug", "--nologo" }
  if framework then
    vim.list_extend(command, { "--framework", framework })
  end

  notify("Building " .. vim.fs.basename(project) .. "…")
  run(command, function(result)
    if result.code ~= 0 then
      notify("Build failed:\n" .. (result.stderr ~= "" and result.stderr or result.stdout), vim.log.levels.ERROR)
      return
    end

    command = {
      "dotnet",
      "msbuild",
      project,
      "-nologo",
      "-getProperty:TargetPath,TargetDir",
      "-property:Configuration=Debug",
    }
    if framework then
      command[#command + 1] = "-property:TargetFramework=" .. framework
    end

    run(command, function(path_result)
      local properties = path_result.code == 0 and decode_msbuild(path_result.stdout) or nil
      local target_path = properties and properties.TargetPath or nil
      if target_path and not is_absolute(target_path) then
        target_path = vim.fs.joinpath(vim.fs.dirname(project), target_path)
      end
      if not target_path or not is_file(target_path) then
        notify("Build succeeded, but MSBuild did not return a valid TargetPath.", vim.log.levels.ERROR)
        return
      end
      callback(target_path)
    end)
  end)
end

---@param project string
---@param profile DotnetLaunchProfile
---@param target_path string
---@return table
local function make_config(project, profile, target_path)
  local env = vim.tbl_extend("force", {}, profile.environmentVariables or {})
  if profile.applicationUrl and env.ASPNETCORE_URLS == nil then
    env.ASPNETCORE_URLS = profile.applicationUrl
  end
  if profile.name ~= DEFAULT_PROFILE_NAME then
    env.DOTNET_LAUNCH_PROFILE = profile.name
  end

  local cwd = profile.workingDirectory or vim.fs.dirname(project)
  if not is_absolute(cwd) then
    cwd = vim.fs.joinpath(vim.fs.dirname(project), cwd)
  end

  return {
    type = "netcoredbg",
    request = "launch",
    name = ("%s: %s"):format(vim.fs.basename(project), profile.name),
    program = target_path,
    cwd = cwd,
    args = parse_command_line(profile.commandLineArgs or ""),
    env = env,
    console = "integratedTerminal",
    stopAtEntry = false,
    justMyCode = false,
    enableStepFiltering = false,
  }
end

---@param project string
---@param profile DotnetLaunchProfile
---@param target_path string
local function start(project, profile, target_path)
  require("dap").run(make_config(project, profile, target_path))
end

---@generic T
---@param items T[]
---@param opts table
---@param callback fun(item: T?)
local function select_if_many(items, opts, callback)
  if #items == 1 then
    callback(items[1])
  else
    vim.ui.select(items, opts, callback)
  end
end

---Select a project and launchSettings.json profile, build it, and start debugging.
---@return nil
function M.launch()
  local root, projects = find_projects()
  if #projects == 0 then
    notify("No .csproj files found.", vim.log.levels.ERROR)
    return
  end

  select_if_many(projects, {
    prompt = "Project to debug",
    format_item = function(project)
      return vim.fs.relpath(root, project) or project
    end,
  }, function(project)
    if not project then
      return
    end

    local profiles = get_profiles(project)
    select_if_many(profiles, {
      prompt = "Launch profile",
      format_item = function(profile)
        return profile.name
      end,
    }, function(profile)
      if not profile then
        return
      end

      get_frameworks(project, function(frameworks)
        local function launch(framework)
          build(project, framework, function(target_path)
            start(project, profile, target_path)
          end)
        end

        if #frameworks > 1 then
          select_if_many(frameworks, { prompt = "Target framework" }, launch)
        else
          launch(frameworks[1])
        end
      end)
    end)
  end)
end

M._parse_command_line = parse_command_line
M._profiles_from_settings = profiles_from_settings
M._make_config = make_config

return M
