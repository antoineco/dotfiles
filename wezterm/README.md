### WezTerm terminal emulator

The configuration files belongs in `~/.config/wezterm` as described in the [documentation][documentation].

On Windows:

```powershell
$installPath = "$Env:USERPROFILE\.config"

if (!(Test-Path $installPath)) {
  New-Item -Type Directory -Path $installPath
}

Copy-Item -Recurse -Path wezterm -Destination $installPath
```

[documentation]: https://wezfurlong.org/wezterm/config/files.html
