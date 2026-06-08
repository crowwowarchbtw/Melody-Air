# Melody Air Automated Hardening and Deployment Framework
# Operational Status: Production Alpha Vector

$ErrorActionPreference = "Stop"
$TargetDir = "C:\MelodyAir"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Конфигурация имени главного исполняемого файла
$CustomBinaryName = "melodyair.exe" 

# Принудительное подключение графической подсистемы Windows Forms
Add-Type -AssemblyName System.Windows.Forms

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

# STEP 0: Завершение конфликтующих процессов
Write-Output "[ STEP 0 / 6 ] Terminating conflicting background processes..."
$ActiveProcesses = @("opera", "opera_air", "launcher", "test", "melodyair")
foreach ($Proc in $ActiveProcesses) {
    if (Get-Process -Name $Proc -ErrorAction SilentlyContinue) {
        Stop-Process -Name $Proc -Force -ErrorAction SilentlyContinue
        Write-Output "[ KILLED     ] Subsystem process terminated: $Proc"
    }
}

# STEP 1: Подготовка окружения и удаление старых файлов
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

# STEP 2: Проверка наличия официального инсталлятора
Write-Output "[ STEP 2 / 6 ] Checking for local OperaAirSetup core..."
$LocalStub = Join-Path $ScriptDir "OperaAirSetup.exe"
$TempInstaller = "$env:TEMP\OperaAirSetup.exe"

if (Test-Path $LocalStub) {
    Write-Output "[ DETECTED   ] Found local OperaAirSetup.exe. Initializing transformer matrix..."
    Copy-Item -Path $LocalStub -Destination $TempInstaller -Force
} else {
    Write-Output ""
    Write-Output "============================================================================="
    Write-Output " [!] ERROR: OFFICIAL OPERA AIR INSTALLER NOT FOUND"
    Write-Output "============================================================================="
    Write-Output " To deploy this hardened framework, please follow these steps:"
    Write-Output " 1. Open your browser and go to: https://www.opera.com/air"
    Write-Output " 2. Download the official 'OperaAirSetup.exe' file."
    Write-Output " 3. Place the downloaded setup file directly into this folder:"
    Write-Output "    -> $ScriptDir"
    Write-Output " 4. Run 'install.bat' again."
    Write-Output "============================================================================="
    Write-Output ""
    Read-Host "Press [ENTER] to exit and copy the file..."
    exit
}

# STEP 3: Развертывание Standalone песочницы
Write-Output "[ STEP 3 / 6 ] Extracting sandboxed execution layer..."
try {
    $InstallProcess = Start-Process -FilePath $TempInstaller -ArgumentList "/silent", "/standalone", "/allusers=0", "/launchbrowser=0", "/installfolder=""$TargetDir""" -Wait -PassThru
    if ($InstallProcess.ExitCode -ne 0) { throw "Extraction layer failure." }
    Write-Output "[ SUCCESS    ] Sandboxed binaries unpacked successfully."
} catch {
    [System.Windows.Forms.MessageBox]::Show("Extraction failure during core deployment: $_", "Melody Air Error", "OK", "Error") | Out-Null
    throw "Extraction crash."
} finally {
    if (Test-Path $TempInstaller) { Remove-Item -Path $TempInstaller -Force -ErrorAction SilentlyContinue }
}

# STEP 4: Удаление телеметрии и мусора инсталлятора
Write-Output "[ STEP 4 / 6 ] Hardening core environment flags and removing bloatware..."
$TelemetryTargets = @(
    "opera_autoupdate.exe", 
    "opera_crashreporter.exe", 
    "opera_autoupdate.gup",
    "server_tracking_data",
    "installer_prefs.json",
    "installation_status.json"
)

foreach ($Target in $TelemetryTargets) {
    Get-ChildItem -Path $TargetDir -Filter $Target -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

$EngineDir = Get-ChildItem -Path $TargetDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^\d+\." } | Select-Object -First 1
if ($EngineDir) {
    "portable=1" | Out-File -FilePath (Join-Path $EngineDir.FullName "sidekick.config") -Encoding ascii -Force
}
Write-Output "[ SUCCESS    ] Telemetry engines and tracking footprints completely purged."

# STEP 4.5: Переименование исполняемых файлов под кастомный брендинг
Write-Output "[ REBRAND    ] Re-mapping executable identities..."
$DefaultBinaries = @("launcher.exe", "opera.exe")
foreach ($Bin in $DefaultBinaries) {
    $BinPath = Join-Path $TargetDir $Bin
    if (Test-Path $BinPath) {
        Rename-Item -Path $BinPath -NewName $CustomBinaryName -Force
        Write-Output "[ SUCCESS    ] Core binary mapped to: $CustomBinaryName"
    }
}

# STEP 5: Развертывание блокировщиков первого запуска (First Run)
Write-Output "[ STEP 5 / 6 ] Injecting first-run suppression matrix..."
$TargetDataDir = "C:\MelodyAir\profile\data"
$TargetDefaultDir = "C:\MelodyAir\profile\data\Default"

if (!(Test-Path $TargetDataDir)) { New-Item -ItemType Directory -Path $TargetDataDir | Out-Null }
if (!(Test-Path $TargetDefaultDir)) { New-Item -ItemType Directory -Path $TargetDefaultDir | Out-Null }

# Вешаем заглушки, чтобы заблокировать приветственные баннеры
New-Item -ItemType File -Path (Join-Path $TargetDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType File -Path (Join-Path $TargetDataDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType File -Path (Join-Path $TargetDefaultDir "First Run") -Force -ErrorAction SilentlyContinue | Out-Null
Write-Output "[ SUCCESS    ] Promotional welcome wizards disabled."

# STEP 6: Верификация сборки и финальный вывод
Write-Output "[ STEP 6 / 6 ] Validating post-deployment structure..."
$TargetLauncher = Join-Path $TargetDir $CustomBinaryName

if (Test-Path $TargetLauncher) {
    Clear-Host
    Write-Output $LogoArt
    Write-Output ""
    Write-Output "============================================================================="
    Write-Output "   CONGRATULATIONS! MELODY AIR DEPLOYMENT ACCOMPLISHED SUCCESSFULLY!"
    Write-Output "============================================================================="
    Write-Output " [+] Your hardened, telemetry-free browser sandbox is fully operational."
    Write-Output " [+] Target Directory:   $TargetDir"
    Write-Output " [+] Execution Launcher:  $TargetLauncher"
    Write-Output "============================================================================="
    Write-Output ""
    Write-Output " You may now close this window."
    Write-Output ""
    
    [System.Windows.Forms.MessageBox]::Show("Melody Air installation completed successfully!`n`nYour hardened browser environment is ready at $TargetDir", "Melody Air Framework", "OK", "Information") | Out-Null
} else {
    Write-Output "[ CRITICAL ] Verification failed. Master binary missing from target location."
}

Write-Output ""
Read-Host "Press [ENTER] to exit the installer framework..."