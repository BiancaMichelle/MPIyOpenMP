# Script PowerShell simple para el proyecto Torneo One Piece
# Uso: .\simple.ps1 [comando]

param(
    [string]$Command = "help"
)

function Write-Info {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Green
}

function Write-Warning {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Red
}

function Show-Help {
    Write-Info "=== Torneo One Piece - MPI/OpenMP ==="
    Write-Host ""
    Write-Host "Comandos disponibles:"
    Write-Host "  .\simple.ps1 build    - Compilar proyecto"
    Write-Host "  .\simple.ps1 run      - Ejecutar torneo"
    Write-Host "  .\simple.ps1 demo     - Demo completa"
    Write-Host "  .\simple.ps1 web      - Servidor web"
    Write-Host "  .\simple.ps1 clean    - Limpiar archivos"
    Write-Host "  .\simple.ps1 help     - Esta ayuda"
    Write-Host ""
    Write-Warning "Requisitos: MPI, Python3, compilador C"
}

function Build-Project {
    Write-Info "Compilando proyecto..."
    
    if (!(Test-Path "src")) {
        Write-Error "Directorio src no encontrado"
        return $false
    }
    
    $cmd = "mpicc -fopenmp -Wall -std=c99 -o src\torneo_onepiece.exe src\torneo_onepiece.c -lcjson -lm"
    Write-Warning "Ejecutando: $cmd"
    
    try {
        Invoke-Expression $cmd
        if ($LASTEXITCODE -eq 0) {
            Write-Info "Compilacion exitosa!"
            return $true
        } else {
            Write-Error "Error en compilacion"
            return $false
        }
    } catch {
        Write-Error "Error: $_"
        return $false
    }
}

function Run-Project {
    Write-Info "Ejecutando torneo..."
    
    if (!(Test-Path "src\torneo_onepiece.exe")) {
        Write-Warning "Ejecutable no encontrado. Compilando..."
        if (!(Build-Project)) {
            return $false
        }
    }
    
    try {
        & mpiexec -n 4 src\torneo_onepiece.exe
        if ($LASTEXITCODE -eq 0) {
            Write-Info "Torneo completado!"
            return $true
        } else {
            Write-Error "Error ejecutando torneo"
            return $false
        }
    } catch {
        Write-Error "Error: $_"
        return $false
    }
}

function Start-Web {
    Write-Info "Iniciando servidor web..."
    
    if (!(Test-Path "web")) {
        Write-Error "Directorio web no encontrado"
        return $false
    }
    
    try {
        Set-Location "web"
        Write-Info "Servidor en http://localhost:8000"
        Write-Warning "Presiona Ctrl+C para detener"
        & python -m http.server 8000
    } catch {
        Write-Error "Error: $_"
    } finally {
        Set-Location ".."
    }
}

function Clean-Project {
    Write-Info "Limpiando archivos..."
    
    if (Test-Path "src\torneo_onepiece.exe") {
        Remove-Item "src\torneo_onepiece.exe" -Force
        Write-Warning "Ejecutable eliminado"
    }
    
    if (Test-Path "output\resultado.json") {
        Remove-Item "output\resultado.json" -Force
        Write-Warning "Resultado eliminado" 
    }
    
    Write-Info "Limpieza completa!"
}

function Run-Demo {
    Write-Info "=== DEMO COMPLETA ==="
    
    # Compilar
    if (!(Build-Project)) {
        Write-Error "Error compilando. Abortando."
        return
    }
    
    # Ejecutar
    if (!(Run-Project)) {
        Write-Error "Error ejecutando. Abortando."
        return
    }
    
    # Web server
    Write-Info "Iniciando servidor web..."
    Write-Info "Abrir: http://localhost:8000/templates/"
    Start-Web
}

# Ejecutar comando
switch ($Command.ToLower()) {
    "build" { Build-Project }
    "run" { Run-Project }
    "web" { Start-Web }
    "clean" { Clean-Project }
    "demo" { Run-Demo }
    "help" { Show-Help }
    default { 
        Write-Error "Comando desconocido: $Command"
        Show-Help
    }
}