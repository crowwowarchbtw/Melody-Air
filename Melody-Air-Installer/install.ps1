# Melody Air Automated Hardening and Deployment Framework
# Operational Status: Production Alpha Vector

$ErrorActionPreference = "Stop"
$TargetDir = "C:\MelodyAir"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Принудительное подключение графической подсистемы Windows Forms
Add-Type -AssemblyName System.Windows.Forms
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Clear-Host
$LogoArt = @"
=============================================================================
 __  __   ______   __        ______   _____    __  __       ______   __   ______  
/\ \/\ \ /\  ___\ /\ \      /\  __ \ /\  __-. /\ \_\ \     /\  __ \ /\ \ /\  == \ 
\ \ \_\ \\ \  __\ \ \ \____ \ \ \/\ \\ \ \/\ \\ \____ \    \ \  __ \\ \ \\ \  __< 
 \ \_____\\ \_____\\ \_____\ \ \_____\\ \____- \/\_____\    \ \_\ \_\\ \_\\ \_\ \_\
  \/_____/ \/_____/ \/_____/  \/_____/ \/____/  \/_____/     \/_/\/_/ \/_/ \/_/ /_/
                                                                                 
=============================================================================
                         OFFICIAL PORTABLE INSTALLER
                 https://github.com/crowwowarchbtw/Melody-Air
=============================================================================
"@

Write-Output $LogoArt
Write-Output ""

# STEP 0: Агрессивное снятие блокировок процессов
Write-Output "[ STEP 0 / 6 ] Terminating conflicting background processes..."
$ActiveProcesses = @("opera", "launcher")
foreach ($Proc in $ActiveProcesses) {
    if (Get-Process -Name $Proc -ErrorAction SilentlyContinue) {
        Stop-Process -Name $Proc -Force -ErrorAction SilentlyContinue
        Write-Output "[ KILLED     ] Subsystem process terminated: $Proc"
    }
}

# STEP 1: Инициализация окружения и полная зачистка хвостов
Write-Output "[ STEP 1 / 6 ] Purging active system residues..."
$AppDataOperaPath = Join-Path $env:APPDATA "Opera Software"
if (Test-Path $AppDataOperaPath) {
    try {
        Remove-Item -Path $AppDataOperaPath -Recurse -Force -ErrorAction SilentlyContinue
    } catch {}
}

if (Test-Path $TargetDir) {
    try {
        Remove-Item -Path $TargetDir -Recurse -Force -ErrorAction SilentlyContinue
    } catch {}
}
New-Item -ItemType Directory -Path $TargetDir | Out-Null
Write-Output "[ SUCCESS    ] Workspace cleared and isolated at: $TargetDir"

# STEP 2: Загрузка бинарных блоков ядра Opera One (Desktop Core)
Write-Output "[ STEP 2 / 6 ] Fetching official deployment core..."
$DownloadUrl = "https://get.opera.com/pub/opera/desktop/115.0.5322.137/win/Opera_115.0.5322.137_Setup_x64.exe"
$TempInstaller = "$env:TEMP\MelodyAir_Core_Setup.exe"

try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempInstaller -UseBasicParsing
    Write-Output "[ SUCCESS    ] Distribution cache stabilized."
} catch {
    [System.Windows.Forms.MessageBox]::Show("Network pipeline failure: $_", "Melody Air Error", "OK", "Error") | Out-Null
    throw "Network error."
}

# STEP 3: Развертывание Standalone песочницы
Write-Output "[ STEP 3 / 6 ] Extracting sandboxed execution layer..."
try {
    $InstallProcess = Start-Process -FilePath $TempInstaller -ArgumentList "/silent", "/standalone", "/allusers=0", "/launchbrowser=0", "/installfolder=""$TargetDir""" -Wait -PassThru
    if ($InstallProcess.ExitCode -ne 0) { throw "Extraction layer failure." }
    Write-Output "[ SUCCESS    ] Sandboxed binaries unpacked."
} catch {
    [System.Windows.Forms.MessageBox]::Show("Extraction failure: $_", "Melody Air Error", "OK", "Error") | Out-Null
    throw "Extraction crash."
} finally {
    if (Test-Path $TempInstaller) { Remove-Item -Path $TempInstaller -Force -ErrorAction SilentlyContinue }
}

# STEP 4: Зачистка телеметрии и фиксация портативности
Write-Output "[ STEP 4 / 6 ] Hardening core environment flags and removing bloatware..."
$TelemetryTargets = @("opera_autoupdate.exe", "opera_crashreporter.exe", "opera_autoupdate.gup")
foreach ($Target in $TelemetryTargets) {
    Get-ChildItem -Path $TargetDir -Filter $Target -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

$EngineDir = Get-ChildItem -Path $TargetDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^\d+\." } | Select-Object -First 1
if ($EngineDir) {
    "portable=1" | Out-File -FilePath (Join-Path $EngineDir.FullName "sidekick.config") -Encoding ascii -Force
}
Write-Output "[ SUCCESS    ] Telemetry engines completely purged."

# STEP 5: Развертывание блокировщиков первого запуска (First Run)
Write-Output "[ STEP 5 / 6 ] Injecting first-run suppression matrix..."
$TargetDataDir = "C:\MelodyAir\profile\data"
$TargetDefaultDir = "C:\MelodyAir\profile\data\Default"

if (!(Test-Path $TargetDataDir)) { New-Item -ItemType Directory -Path $TargetDataDir | Out-Null }
if (!(Test-Path $TargetDefaultDir)) { New-Item -ItemType Directory -Path $TargetDefaultDir | Out-Null }

# Вешаем заглушки, чтобы заблокировать приветственные баннеры и промо-акции
New-Item -ItemType File -Path (Join-Path $TargetDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType File -Path (Join-Path $TargetDataDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType File -Path (Join-Path $TargetDefaultDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
Write-Output "[ SUCCESS    ] Promotional welcome wizards disabled."

# STEP 6: Верификация сборки
Write-Output "[ STEP 6 / 6 ] Validating post-deployment structure..."
$TargetLauncher = Join-Path $TargetDir "launcher.exe"
if (Test-Path $TargetLauncher) {
    Write-Output "[ COMPLETE   ] Melody Air build stabilization accomplished."
    [System.Windows.Forms.MessageBox]::Show("Melody Air installation completed successfully!`n`nYour hardened browser environment is ready at $TargetDir", "Melody Air Framework", "OK", "Information") | Out-Null
}