local dotnet_debug = require("utils.dotnet_debug")

assert(vim.deep_equal(dotnet_debug._parse_command_line([[--name "Jane Doe" --path one\ two ""]]), {
  "--name",
  "Jane Doe",
  "--path",
  "one two",
  "",
}))

assert(vim.deep_equal(dotnet_debug._parse_command_line([=[--path C:\temp\file --regex \d+ "C:\Program Files\app"]=]), {
  "--path",
  [[C:\temp\file]],
  "--regex",
  [[\d+]],
  [[C:\Program Files\app]],
}))

local settings = {
  profiles = {
    Web = {
      commandName = "Project",
      applicationUrl = "https://localhost:7001",
      workingDirectory = "run",
      environmentVariables = { ASPNETCORE_ENVIRONMENT = "Development" },
    },
    Console = { commandName = "Project", commandLineArgs = "--verbose" },
    IIS = { commandName = "IISExpress" },
  },
}
local profiles = dotnet_debug._profiles_from_settings(settings)

assert(#profiles == 2)
assert(profiles[1].name == "Console")
assert(profiles[2].name == "Web")
assert(settings.profiles.Console.name == nil)

local fallback = dotnet_debug._profiles_from_settings(nil)
assert(#fallback == 1)
assert(fallback[1].name == "Default (no launch profile)")

local config = dotnet_debug._make_config("/work/App/App.csproj", profiles[2], "/work/App/bin/Debug/net10.0/App.dll")
assert(config.type == "netcoredbg")
assert(config.request == "launch")
assert(config.cwd == "/work/App/run")
assert(config.program == "/work/App/bin/Debug/net10.0/App.dll")
assert(config.env.ASPNETCORE_ENVIRONMENT == "Development")
assert(config.env.ASPNETCORE_URLS == "https://localhost:7001")
assert(config.env.DOTNET_LAUNCH_PROFILE == "Web")
assert(settings.profiles.Web.environmentVariables.ASPNETCORE_URLS == nil)
