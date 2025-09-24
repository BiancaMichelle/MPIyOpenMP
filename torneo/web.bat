@echo off
REM Script para iniciar servidor web
REM Uso: web.bat

echo [92m🌐 Iniciando servidor web...[0m

if not exist "web" (
    echo [91m❌ Directorio web no encontrado[0m
    pause
    exit /b 1
)

cd web

echo [96m📱 Servidor iniciado en: http://localhost:8000[0m
echo [93m💡 Abrir navegador en: http://localhost:8000/templates/[0m
echo [91m⚠️  Presiona Ctrl+C para detener el servidor[0m
echo.

python -m http.server 8000

cd ..