@echo off
REM Script para ejecutar el torneo
REM Uso: run.bat [numero_procesos]

set PROCESSES=%1
if "%PROCESSES%"=="" set PROCESSES=4

echo [92m🏴‍☠️ Ejecutando Torneo One Piece...[0m
echo [96mProcesos MPI: %PROCESSES%[0m

if not exist "src\torneo_onepiece.exe" (
    echo [91m❌ Ejecutable no encontrado. Compilando primero...[0m
    call build.bat
    if %ERRORLEVEL% NEQ 0 exit /b 1
)

echo [93mEjecutando: mpiexec -n %PROCESSES% src\torneo_onepiece.exe[0m

mpiexec -n %PROCESSES% src\torneo_onepiece.exe

if %ERRORLEVEL% EQU 0 (
    echo [92m✅ Torneo completado exitosamente[0m
    
    REM Mostrar resultado si existe
    if exist "output\resultado.json" (
        echo [96m🏆 Resultado guardado en output\resultado.json[0m
        echo [93m💡 Usa 'web.bat' para ver resultados en navegador[0m
    )
) else (
    echo [91m❌ Error ejecutando el torneo[0m
)

pause