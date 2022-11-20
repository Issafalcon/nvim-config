local path = require("utils.path")

M = {}
M.opts = {
  cmd = {
    "dotnet",
    path.concat({ vim.fn.stdpath("data"), "mason", "packages", "omnisharp", "OmniSharp.dll" }),
    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = true,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = true,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = true,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,
  },
}

local extended_definitions = fignvim.plug.load_module_file("omnisharp_extended")
-- local neosharper = fignvim.plug.load_module_file("neosharper")

if extended_definitions then
  M.opts.handlers = {
    ["textDocument/definition"] = extended_definitions.handler,
  }
end

if neosharper then
  M.opts.on_attach = function(client, bufnr)
    -- neosharper.on_attach(client, bufnr)
  end
end

return M
