#!/usr/bin/env python3
"""
Servidor web simple para el Simulador One Piece
Solo sirve archivos estáticos - sin dependencias complejas
"""

import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

class TournamentServer(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(__file__), **kwargs)
    
    def do_GET(self):
        # Redirección automática a la demo
        if self.path == '/':
            self.send_response(302)
            self.send_header('Location', '/templates/demo.html')
            self.end_headers()
            return
        
        super().do_GET()

def start_server(port=8000):
    server_address = ('', port)
    httpd = HTTPServer(server_address, TournamentServer)
    
    print(f"🚀 Servidor iniciado en http://localhost:{port}")
    print(f"📱 Demo automática: http://localhost:{port}/templates/demo.html")
    print("⚡ Presiona Ctrl+C para detener")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Servidor detenido")

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    start_server(port)