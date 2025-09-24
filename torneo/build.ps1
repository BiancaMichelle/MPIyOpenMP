# PowerShell Script equivalente al Makefile para Windows
# Uso: .\build.ps1 [comando]

param(
    [string]$Command = "all"
)

# Colores para PowerShell
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Blue = "Cyan"

# Variables de configuración
$CC = "mpicc"
$CFLAGS = "-fopenmp -Wall -std=c99"
$LIBS = "-lcjson -lm"
$TARGET = "src\torneo_onepiece.exe"
$SOURCE = "src\torneo_onepiece.c"
$CONFIG_FILE = "config\config.json"
$OUTPUT_FILE = "output\resultado.json"

function Write-ColoredText {
    param([string]$Text, [string]$Color)
    Write-Host $Text -ForegroundColor $Color
}

function Show-Help {
    Write-ColoredText "🏴‍☠️ Torneo One Piece - MPI/OpenMP Demo" $Green
    Write-Host ""
    Write-ColoredText "Comandos disponibles:" $Yellow
    Write-Host "  .\build.ps1           - Compilar el programa"
    Write-Host "  .\build.ps1 run       - Ejecutar con 4 procesos MPI"
    Write-Host "  .\build.ps1 demo      - Demo completa con interfaz web"
    Write-Host "  .\build.ps1 test      - Ejecutar tests básicos"
    Write-Host "  .\build.ps1 clean     - Limpiar archivos generados"
    Write-Host "  .\build.ps1 web       - Solo iniciar servidor web"
    Write-Host "  .\build.ps1 help      - Mostrar esta ayuda"
    Write-Host ""
    Write-ColoredText "📖 Ejemplo de uso:" $Green
    Write-Host "  .\build.ps1; .\build.ps1 demo"
    Write-Host ""
    Write-ColoredText "⚠️  Requisitos:" $Yellow
    Write-Host "  - MPI instalado (mpicc disponible)"
    Write-Host "  - Librería cJSON"
    Write-Host "  - Python3 (para servidor web)"
}

function Test-Dependencies {
    Write-ColoredText "🔍 Verificando dependencias..." $Blue
    
    $allGood = $true
    
    # Verificar mpicc
    try {
        $null = & mpicc --version 2>$null
        Write-ColoredText "✅ mpicc encontrado" $Green
    } catch {
        Write-ColoredText "❌ mpicc no encontrado" $Red
        Write-ColoredText "💡 Instala Microsoft MPI o OpenMPI" $Yellow
        $allGood = $false
    }
    
    # Verificar Python3
    try {
        $null = & python --version 2>$null
        Write-ColoredText "✅ Python encontrado" $Green
    } catch {
        Write-ColoredText "❌ Python no encontrado" $Red
        Write-ColoredText "💡 Instala Python desde python.org" $Yellow
        $allGood = $false
    }
    
    return $allGood
}

function Build-Project {
    Write-ColoredText "🔨 Compilando proyecto..." $Blue
    
    # Crear directorio de salida si no existe
    if (!(Test-Path "src")) {
        New-Item -ItemType Directory -Path "src" -Force | Out-Null
    }
    
    try {
        $compileCmd = "$CC $CFLAGS -o $TARGET $SOURCE $LIBS"
        Write-ColoredText "Ejecutando: $compileCmd" $Yellow
        
        Invoke-Expression $compileCmd
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredText "✅ Compilación exitosa!" $Green
            return $true
        } else {
            Write-ColoredText "❌ Error en compilación" $Red
            return $false
        }
    } catch {
        Write-ColoredText "❌ Error ejecutando compilador: $_" $Red
        return $false
    }
}

function Run-Torneo {
    param([int]$Processes = 4)
    
    if (!(Test-Path $TARGET)) {
        Write-ColoredText "❌ Ejecutable no encontrado. Compilando primero..." $Yellow
        if (!(Build-Project)) {
            return $false
        }
    }
    
    Write-ColoredText "🚀 Ejecutando torneo con $Processes procesos MPI..." $Blue
    
    try {
        & mpiexec -n $Processes $TARGET
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredText "✅ Torneo completado exitosamente" $Green
            
            # Mostrar resultado si existe
            if (Test-Path $OUTPUT_FILE) {
                Write-ColoredText "🏆 Resultado del torneo:" $Blue
                Get-Content $OUTPUT_FILE | ConvertFrom-Json | ConvertTo-Json -Depth 3
            }
            return $true
        } else {
            Write-ColoredText "❌ Error ejecutando el torneo" $Red
            return $false
        }
    } catch {
        Write-ColoredText "❌ Error: $_" $Red
        return $false
    }
}

function Start-WebServer {
    Write-ColoredText "🌐 Iniciando servidor web..." $Blue
    
    if (!(Test-Path "web")) {
        Write-ColoredText "❌ Directorio web no encontrado" $Red
        return $false
    }
    
    try {
        Set-Location "web"
        Write-ColoredText "Servidor iniciado en http://localhost:8000" $Green
        Write-ColoredText "Presiona Ctrl+C para detener" $Yellow
        & python -m http.server 8000
    } catch {
        Write-ColoredText "❌ Error iniciando servidor: $_" $Red
        return $false
    } finally {
        Set-Location ".."
    }
}

function Clean-Project {
    Write-ColoredText "🧹 Limpiando archivos..." $Blue
    
    if (Test-Path $TARGET) {
        Remove-Item $TARGET -Force
        Write-ColoredText "🗑️  Ejecutable eliminado" $Yellow
    }
    
    if (Test-Path $OUTPUT_FILE) {
        Remove-Item $OUTPUT_FILE -Force
        Write-ColoredText "🗑️  Archivo de resultados eliminado" $Yellow
    }
    
    Write-ColoredText "✅ Limpieza completa!" $Green
}

function Run-Demo {
    Write-ColoredText "🎬 Iniciando demo completa..." $Green
    
    # Verificar dependencias
    if (!(Test-Dependencies)) {
        Write-ColoredText "❌ Faltan dependencias. Abortando." $Red
        return
    }
    
    # Compilar
    if (!(Build-Project)) {
        Write-ColoredText "❌ Error en compilación. Abortando." $Red
        return
    }
    
    # Ejecutar torneo
    if (!(Run-Torneo)) {
        Write-ColoredText "❌ Error ejecutando torneo. Abortando." $Red
        return
    }
    
    # Iniciar servidor web en segundo plano
    Write-ColoredText "🌐 Iniciando servidor web..." $Blue
    Write-ColoredText "📱 Abrir en navegador: http://localhost:8000/templates/resultados.html" $Green
    
    Start-Job -ScriptBlock {
        Set-Location $using:PWD
        Set-Location "web"
        python -m http.server 8000
    } | Out-Null
    
    Write-ColoredText "🎉 Demo completa iniciada!" $Green
    Write-ColoredText "🌍 Servidor web corriendo en segundo plano" $Blue
    Write-ColoredText "Use 'Get-Job | Stop-Job' para detener el servidor" $Yellow
}

# Función principal
switch ($Command.ToLower()) {
    "all" { Build-Project }
    "build" { Build-Project }
    "run" { Run-Torneo }
    "demo" { Run-Demo }
    "test" { Run-Torneo -Processes 2 }
    "clean" { Clean-Project }
    "web" { Start-WebServer }
    "help" { Show-Help }
    "install-deps" {
        Write-ColoredText "📦 Guía de instalación para Windows:" $Yellow
        Write-Host ""
        Write-Host "1. Microsoft MPI:"
        Write-Host "   Descargar desde: https://www.microsoft.com/en-us/download/details.aspx?id=57467"
        Write-Host ""
        Write-Host "2. Python 3:"
        Write-Host "   Descargar desde: https://www.python.org/downloads/"
        Write-Host ""
        Write-Host "3. Visual Studio Build Tools (para compilador C):"
        Write-Host "   Descargar desde: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022"
        Write-Host ""
        Write-Host "4. cJSON (opcional - para compilación completa):"
        Write-Host "   Usar vcpkg: vcpkg install cjson"
    }
    default {
        Write-ColoredText "❌ Comando desconocido: $Command" $Red
        Write-ColoredText "Use 'build.ps1 help' para ver comandos disponibles" $Yellow
    }
}