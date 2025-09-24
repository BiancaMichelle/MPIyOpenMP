@echo off
REM Script para demo completa
REM Uso: demo.bat

echo [92m🎬 Iniciando demo completa del Torneo One Piece...[0m
echo.

REM Compilar
echo [96m🔨 Paso 1: Compilación...[0m
call build.bat
if %ERRORLEVEL% NEQ 0 (
    echo [91m❌ Error en compilación. Abortando demo.[0m
    pause
    exit /b 1
)

echo.

REM Ejecutar torneo
echo [96m🏴‍☠️ Paso 2: Ejecutando torneo...[0m
mpiexec -n 4 src\torneo_onepiece.exe
if %ERRORLEVEL% NEQ 0 (
    echo [91m❌ Error ejecutando torneo. Abortando demo.[0m
    pause
    exit /b 1
)

echo.

REM Iniciar servidor web
echo [96m🌐 Paso 3: Iniciando servidor web...[0m
echo [92m🎉 Demo completa iniciada![0m
echo.
echo [93m📱 Abrir navegador en:[0m
echo    http://localhost:8000/templates/configuracion.html
echo    http://localhost:8000/templates/resultados.html
echo.
echo [91m⚠️  Presiona Ctrl+C para detener[0m

cd web
python -m http.server 8000
cd ..