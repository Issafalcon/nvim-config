M = {}
local cmd

if vim.fn.has("win32") == 1 then
  cmd = { "cmd.exe", "/C", "omnisharp" }
else
  cmd = {
    fignvim.path.concat({ vim.fn.stdpath("data"), "mason", "packages", "omnisharp", "omnisharp" }),
  }
end

M.opts = {
  cmd = cmd,
  settings = {
    FormattingOptions = {
      -- Enables support for reading code style, naming convention and analyzer
      -- settings from .editorconfig.
      EnableEditorConfigSupport = true,
      -- Specifies whether 'using' directives should be grouped and sorted during
      -- document formatting.
      OrganizeImports = true,
    },
    MsBuild = {
      -- If true, MSBuild project system will only load projects for files that
      -- were opened in the editor. This setting is useful for big C# codebases
      -- and allows for faster initialization of code navigation features only
      -- for projects that are relevant to code that is being edited. With this
      -- setting enabled OmniSharp may load fewer projects and may thus display
      -- incomplete reference lists for symbols.
      LoadProjectsOnDemand = nil,
    },
    RoslynExtensionsOptions = {
      -- Enables support for roslyn analyzers, code fixes and rulesets.
      EnableAnalyzersSupport = true,
      -- Enables support for showing unimported types and unimported extension
      -- methods in completion lists. When committed, the appropriate using
      -- directive will be added at the top of the current file. This option can
      -- have a negative impact on initial completion responsiveness,
      -- particularly for the first few completion sessions after opening a
      -- solution.
      EnableImportCompletion = nil,
      -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      -- true
      AnalyzeOpenDocumentsOnly = nil,
    },
    Sdk = {
      -- Specifies whether to include preview versions of the .NET SDK when
      -- determining which version to use for project loading.
      IncludePrereleases = true,
    },
  },
}

local extended_definitions_ok, extended_definitions = pcall(require, "omnisharp_extended")
-- local neosharper = fignvim.plug.load_module_file("neosharper")

if extended_definitions then M.opts.handlers = {
  ["textDocument/definition"] = extended_definitions.handler,
} end

-- if neosharper then
--   M.opts.on_attach = function(client, bufnr)
--     neosharper.on_attach(client, bufnr)
--   end
-- end

return M
