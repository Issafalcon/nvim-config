# Debugging

DAP (nvim-dap + dap-ui) is the debugger for Python, JS/TS, Lua, and .NET. This page covers the .NET launch-profile flow, which is meant to feel like VS Code: pick a `launchSettings.json` profile (or a default when none exist), build, and start under the debugger.

## Prerequisites

- .NET SDK on `PATH` (`dotnet`)
- Mason package `netcoredbg` (see `lua/plugins/mason.lua`)
- A `.csproj` in the workspace. Roslyn is optional but preferred: `:Roslyn target` sets `vim.g.roslyn_nvim_selected_solution`, which is the project search root.

## Starting a .NET debug session

From a C# buffer with no active DAP session, **`<F9>`** runs the launch flow. After a session exists, **`<F9>`** continues like a normal debugger.

| Key / command | Action |
|---|---|
| `:DotnetDebug` | Always run the .NET launch-profile flow |
| `<leader>da` | Same as `:DotnetDebug` |
| `<F9>` | Launch that flow on `cs` when idle; otherwise `dap.continue()` |

Pickers appear only when there is more than one choice (project, profile, or target framework). A single project, a single `Project` profile, or a single TFM starts without a prompt.

### What happens

1. **Find projects** — search `.csproj` files under the Roslyn-selected solution directory, else the nearest `.sln` / `.slnx`, else the git root / cwd. The project nearest the current buffer is listed first.
2. **Read profiles** — `Properties/launchSettings.json` next to the chosen `.csproj`. Only profiles with `"commandName": "Project"` are used (same restriction as VS Code `coreclr` / `dotnet run -lp`). IIS Express and similar are ignored.
3. **Default profile** — if there is no usable profile, a synthetic **Default (no launch profile)** is used so console apps still launch.
4. **Framework** — `dotnet msbuild -getProperty:TargetFramework,TargetFrameworks`. Multi-targeted projects get a TFM picker.
5. **Build** — `dotnet build --configuration Debug` (plus `--framework` when a TFM was chosen).
6. **Launch** — nvim-dap `request = "launch"` through netcoredbg with the built `TargetPath`. Netcoredbg starts the process (`dotnet <dll> …`); this is not an attach-to-PID flow.

dap-ui opens on launch. Output uses the integrated DAP terminal.

## `launchSettings.json`

Put this next to the project, not in `.vscode/launch.json`:

```
MyApp/Properties/launchSettings.json
```

Example:

```json
{
  "profiles": {
    "https": {
      "commandName": "Project",
      "commandLineArgs": "--verbose",
      "workingDirectory": ".",
      "applicationUrl": "https://localhost:7152;http://localhost:5105",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

Mapped into the DAP config:

| Profile field | Debugger |
|---|---|
| `commandLineArgs` | `args` (quoted / escaped like a shell line) |
| `workingDirectory` | `cwd` (relative paths are from the `.csproj` directory) |
| `environmentVariables` | `env` |
| `applicationUrl` | `ASPNETCORE_URLS` if that variable is not already set |
| profile name | `DOTNET_LAUNCH_PROFILE` (omitted for the synthetic default) |

`justMyCode` and `enableStepFiltering` are off so stepping into library code works.

## Attach to a running process

The filetype `cs` DAP configs still include **attach - netcoredbg** (`processId` picker). Use `:DapContinue` / the usual DAP config picker when you already have a process and do not want the build-and-launch flow.

## Other languages

| Key | Action |
|---|---|
| `<F5>` | Launch the Lua OSV debug server (not .NET) |
| `<leader>db` / `<leader>dB` | Toggle / conditional breakpoint (persisted) |
| `<leader>de` | Exception breakpoints |
| `<leader>dbc` | Clear breakpoints |
| `<leader>dj` / `<leader>dl` / `<leader>dk` | Step into / over / out |
| `<leader>dn` / `<leader>dp` | Stack frame down / up |
| `<leader>dc` | Disconnect (does not kill the debuggee) |
| `<leader>dC` | Terminate (kills the debuggee) |
| `<F12>` | Hover |
| `<leader>d?` | Scopes |
| `<leader>dr` | REPL |

Python uses debugpy via nvim-dap-python. JS/TS uses vscode-js-debug. Configurations live in `lua/dap_configs.lua`.

## Troubleshooting

| Symptom | Check |
|---|---|
| `No .csproj files found` | Open a file inside the repo, or `:Roslyn target` so the solution path is set |
| Build failed | Notification shows `dotnet build` stderr; fix compile errors first |
| `MSBuild did not return a valid TargetPath` | Confirm Debug output exists; for multi-TFM, pick the framework you actually built |
| Wrong URLs / env | Only `commandName: Project` profiles apply; `applicationUrl` is ignored if `ASPNETCORE_URLS` is already in the profile |
| Picker every time | Expected when several `.csproj` files or several Project profiles exist |
| Attaching instead of launching | Use `:DotnetDebug` / `<leader>da`; attach is a separate DAP configuration |
