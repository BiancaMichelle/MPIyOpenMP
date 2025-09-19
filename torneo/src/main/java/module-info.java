module com.example.torneo {
    requires javafx.controls;
    requires javafx.fxml;
    requires transitive javafx.graphics;
    requires java.desktop;

    opens com.example to javafx.fxml;
    exports com.example;
}
