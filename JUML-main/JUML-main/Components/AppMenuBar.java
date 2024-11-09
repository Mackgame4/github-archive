package Components;

import javax.swing.Icon;
import javax.swing.JButton;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.UIManager;
import javax.swing.JFrame;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import Classes.ConfigReader;

public class AppMenuBar {
    public static void configureMenuBar(JFrame frame, ConfigReader configReader) {
        JMenuBar menuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("File");
        //JMenu editMenu = new JMenu("Edit");
        JMenu viewMenu = new JMenu("View");
        JMenu helpMenu = new JMenu("Help");
        menuBar.add(fileMenu);
        //menuBar.add(editMenu);
        menuBar.add(viewMenu);
        menuBar.add(helpMenu);
        frame.setJMenuBar(menuBar);

        // File menu
        Icon fileIcon = UIManager.getIcon("FileView.fileIcon");
        Icon saveIcon = UIManager.getIcon("FileView.floppyDriveIcon");
        Icon saveAsIcon = UIManager.getIcon("FileView.hardDriveIcon");
        Icon openIcon = UIManager.getIcon("FileView.directoryIcon");
        Icon exitIcon = UIManager.getIcon("FileView.computerIcon");
        Icon aboutIcon = UIManager.getIcon("OptionPane.questionIcon");

        JMenuItem newMenuItem = new JMenuItem("New", fileIcon);
        JMenuItem openMenuItem = new JMenuItem("Open", openIcon);
        JMenuItem saveMenuItem = new JMenuItem("Save", saveIcon);
        JMenuItem saveAsMenuItem = new JMenuItem("Save As", saveAsIcon);
        JMenuItem exitMenuItem = new JMenuItem("Exit", exitIcon);
        fileMenu.add(newMenuItem);
        fileMenu.add(openMenuItem);
        fileMenu.add(saveMenuItem);
        fileMenu.add(saveAsMenuItem);
        fileMenu.add(exitMenuItem);

        exitMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                System.exit(0);
            }
        });

        // Edit menu
        /*JMenuItem undoMenuItem = new JMenuItem("Undo");
        JMenuItem redoMenuItem = new JMenuItem("Redo");
        editMenu.add(undoMenuItem);
        editMenu.add(redoMenuItem);*/

        // View menu
        Icon fullscreenIcon = UIManager.getIcon("InternalFrame.icon");
        JMenuItem fullscreenMenuItem = new JMenuItem("Full Screen", fullscreenIcon);
        viewMenu.add(fullscreenMenuItem);

        fullscreenMenuItem.addActionListener(new ActionListener() {
            boolean isFullScreen = false;
            public void actionPerformed(ActionEvent e) {
                if (isFullScreen) {
                    frame.setExtendedState(JFrame.NORMAL);
                    isFullScreen = false;
                } else {
                    frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
                    isFullScreen = true;
                }
            }
        });

        // Help menu
        JMenuItem aboutMenuItem = new JMenuItem("About", aboutIcon);
        helpMenu.add(aboutMenuItem);

        aboutMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String appName = configReader.getPropertyString("app.name");
                String appDesc = configReader.getPropertyString("app.description");
                String appVersion = configReader.getPropertyString("app.version");
                String appAuthor = configReader.getPropertyString("app.author");
                String appLicense = configReader.getPropertyString("app.license");
                String appUrl = configReader.getPropertyString("app.url");
                JButton websiteButton = new JButton("Website");
                websiteButton.addActionListener(new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            java.awt.Desktop.getDesktop().browse(java.net.URI.create(appUrl));
                        } catch (java.io.IOException ex) {
                            System.out.println(ex);
                        }
                    }
                });
                String appRepoUrl = configReader.getPropertyString("app.repoUrl");
                JButton githubButton = new JButton("Github");
                githubButton.addActionListener(new ActionListener() {
                    public void actionPerformed(ActionEvent e) {
                        try {
                            java.awt.Desktop.getDesktop().browse(java.net.URI.create(appRepoUrl));
                        } catch (java.io.IOException ex) {
                            System.out.println(ex);
                        }
                    }
                });
                JButton[] buttons = { websiteButton, githubButton };
                Object[] message = { appName+"\nVersion: "+appVersion+"\nLicense: "+appLicense+"\n\n"+appDesc+"\n\nDeveloped by: \n@"+appAuthor+"\n\n", buttons };
                JOptionPane.showMessageDialog(null, message, "About", JOptionPane.INFORMATION_MESSAGE);
            }
        });
    }
}
