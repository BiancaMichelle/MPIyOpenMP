package com.example;

import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;

public class PrimaryController {
    @FXML
    private Label titulo;
    @FXML
    private Label datos;
    @FXML
    private ImageView imagen;

    @FXML
    public void initialize() {
        Campeon campeon = JsonReader.leerCampeon();
        if (campeon != null) {
            titulo.setText("🏆 Campeón del Torneo One Piece 🏆");
            datos.setText("Universo " + campeon.getUniverso() + " - " 
                + campeon.getPirata() + " (Poder: " + campeon.getPoder() + ")");
            
            String imgPath = "/img/" + campeon.getPirata().toLowerCase() + ".png";
            imagen.setImage(new Image(getClass().getResourceAsStream(imgPath)));
        }
    }
}
