package com.example;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import java.io.IOException;


/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;

    @Override
    public void start(Stage stage) {
        // Leemos el archivo JSON generado por C
        Campeon campeon = JsonReader.leerCampeon();

        Label titulo = new Label("🏆 Campeón del Torneo One Piece 🏆");
        Label datos = new Label(
            "Universo " + campeon.getUniverso() +
            " - " + campeon.getPirata() +
            " (Poder: " + campeon.getPoder() + ")"
        );

        // Imagen del pirata
        String imagenPath = "file:resources/images/" + campeon.getPirata().toLowerCase() + ".png";
        ImageView img = new ImageView(new Image(imagenPath));
        img.setFitHeight(200);
        img.setPreserveRatio(true);

        VBox root = new VBox(15, titulo, datos, img);
        root.setStyle("-fx-alignment: center; -fx-padding: 20;");

        scene = new Scene(root, 400, 400);
        stage.setTitle("Torneo One Piece");
        stage.setScene(scene);
        stage.show();
    }

    static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }

    private static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
        return fxmlLoader.load();
    }

    public static void main(String[] args) {
        launch();
    }

}