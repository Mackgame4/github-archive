//import javax.swing.*; // Swing is a GUI toolkit for Java (already included in Java SE)
//import java.awt.*; // Abstract Window Toolkit
//import java.awt.event.*; // Needed for ActionListener and ActionEvent

import javax.swing.JFrame;
import javax.swing.WindowConstants;
import javax.swing.ImageIcon;

import java.awt.Container;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Toolkit;

import Classes.ConfigReader;

import Components.AppMenuBar;
import Components.AppToolPanel;
import Components.AppCanvasPanel;

public class JUML extends JFrame {
    static ConfigReader configReader = new ConfigReader();

    private static final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();

    private static void configureWindow(JFrame GUI) {
        int screenWidth = screenSize.width / 2 + 300;
        int screenHeight = screenSize.height / 2 + 300;
        GUI.setTitle(configReader.getPropertyString("app.name"));
        GUI.setSize(screenWidth, screenHeight);
        GUI.setLocationRelativeTo(null);
        GUI.setVisible(true);
        GUI.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    }

    public void init() {
        Container pane = this.getContentPane();
        pane.setLayout(new BorderLayout());
        AppMenuBar.configureMenuBar(this, configReader);

        // Create two panels, one for the UML diagram and one for the tools
        AppCanvasPanel canvasPanel = new AppCanvasPanel(pane);

        AppToolPanel.configureToolPanel(pane, canvasPanel); // create a tool panel with buttons
    }

    public static void main(String[] args) {
        JUML GUI = new JUML();
        GUI.init();
        ImageIcon icon = new ImageIcon("Images/"+configReader.getPropertyString("app.icon"));
        GUI.setIconImage(icon.getImage());
        configureWindow(GUI);
    }
}