### Windows Terminal

Settings for the Windows Terminal.

[Fragment extensions][json-fragments] belong in `%LOCALAPPDATA%\Microsoft\Windows Terminal\Fragments\`.

```powershell
$installPath = "$Env:LocalAppData\Microsoft\Windows Terminal"

if (!(Test-Path $installPath)) {
  New-Item -Type Directory -Path $installPath
}

Copy-Item -Recurse -Path Fragments -Destination $installPath
```

[json-fragments]: https://docs.microsoft.com/en-us/windows/terminal/json-fragment-extensions
