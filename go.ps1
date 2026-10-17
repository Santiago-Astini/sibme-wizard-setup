# Sibme Wizard starter for Windows PowerShell (public; holds no secrets). For the Terminal panel in the Claude app,
# which opens PowerShell on Windows. It finds Git Bash and runs the normal starter (go) in it, so the key question and
# the setup work exactly as on a Mac.
#   Everyone:              irm https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go.ps1 | iex
#   Owner's test copy:     $env:SIBME_CHANNEL = 'staging'; irm https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go.ps1 | iex
#   Only check (no setup): $env:SIBME_GO_CHECK = '1'; irm .../go.ps1 | iex
# Source: package/plugin/go.ps1 in the Sibme Wizard source repo (copied to the public repo by hand on each change).

$ErrorActionPreference = 'Stop'
$goUrl = 'https://raw.githubusercontent.com/Santiago-Astini/sibme-wizard-setup/main/go'
$channel = if ($env:SIBME_CHANNEL) { $env:SIBME_CHANNEL } else { 'main' }

# Git Bash: the usual places (all users, or only this user), then Git's own folder from PATH.
$candidates = @(
    (Join-Path $env:ProgramFiles 'Git\bin\bash.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'Git\bin\bash.exe'),
    (Join-Path $env:LOCALAPPDATA 'Programs\Git\bin\bash.exe')
)
$gitCmd = Get-Command git.exe -ErrorAction SilentlyContinue
if ($gitCmd) { $candidates += (Join-Path (Split-Path (Split-Path $gitCmd.Source)) 'bin\bash.exe') }
$bash = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if (-not $bash) {
    Write-Host ''
    Write-Host 'The Sibme Wizard needs Git for Windows (it includes Git Bash). It is not on this computer yet.' -ForegroundColor Yellow
    Write-Host '  1. Install it from https://git-scm.com/downloads (keep the default options; about 5 minutes).'
    Write-Host '  2. Quit Claude completely and open it again.'
    Write-Host '  3. Paste this line in the Terminal panel again.'
    if (Get-Command winget.exe -ErrorAction SilentlyContinue) {
        Write-Host '  Or install it from here: winget install --id Git.Git -e'
    }
    return
}

if ($env:SIBME_GO_CHECK -eq '1') {
    Write-Host "Git Bash found: $bash"
    # no quote marks inside: Windows PowerShell 5.1 drops them when it passes text to another program
    & $bash -c 'if test -r /dev/tty; then echo Keyboard input OK; else echo Keyboard input NOT available; fi'
    return
}

# Run the normal starter in Git Bash. It asks for the key itself (hidden) and runs the setup.
$arg = if ($channel -eq 'staging') { ' -s staging' } else { '' }
& $bash -c "curl -fsSL $goUrl | bash$arg"
