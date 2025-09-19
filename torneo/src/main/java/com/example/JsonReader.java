package com.example;

import java.nio.file.Files;
import java.nio.file.Paths;

public class JsonReader {
    public static Campeon leerCampeon() {
        try {
            String content = new String(Files.readAllBytes(Paths.get("resultado.json")));
            
            // Parser JSON simple para el formato esperado
            String pirata = extraerValor(content, "pirata");
            int poder = Integer.parseInt(extraerValor(content, "poder"));
            int universo = Integer.parseInt(extraerValor(content, "universo"));
            
            return new Campeon(pirata, poder, universo);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private static String extraerValor(String json, String campo) {
        String patron = "\"" + campo + "\"";
        int inicio = json.indexOf(patron);
        if (inicio == -1) return "";
        
        inicio = json.indexOf(":", inicio) + 1;
        while (inicio < json.length() && (json.charAt(inicio) == ' ' || json.charAt(inicio) == '\t')) {
            inicio++;
        }
        
        char primerChar = json.charAt(inicio);
        if (primerChar == '"') {
            // Es un string
            inicio++;
            int fin = json.indexOf('"', inicio);
            return json.substring(inicio, fin);
        } else {
            // Es un número
            int fin = inicio;
            while (fin < json.length() && Character.isDigit(json.charAt(fin))) {
                fin++;
            }
            return json.substring(inicio, fin);
        }
    }
}
