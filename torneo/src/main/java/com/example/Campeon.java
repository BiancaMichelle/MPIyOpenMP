package com.example;

public class Campeon {
    private String pirata;
    private int poder;
    private int universo;

    public Campeon(String pirata, int poder, int universo) {
        this.pirata = pirata;
        this.poder = poder;
        this.universo = universo;
    }

    public String getPirata() {
        return pirata;
    }
    
    public int getPoder() {
        return poder;
    }
    
    public int getUniverso() {
        return universo;
    }
}
