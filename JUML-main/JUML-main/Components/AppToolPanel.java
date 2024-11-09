package Components;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.Box;
import javax.swing.BoxLayout;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class AppToolPanel {
    static final int iconSize = 15;
    static final int buttonWidth = 200;
    static final int buttonHeight = 30;

    private static JButton addToolButton(JPanel panel, String buttonText, String imagePath) {
        ImageIcon icon = new ImageIcon(imagePath);
        Icon resizedIcon = new ImageIcon(icon.getImage().getScaledInstance(iconSize, iconSize, java.awt.Image.SCALE_SMOOTH));
        JButton button = new JButton(buttonText, resizedIcon);
        //button.setPreferredSize(new Dimension(buttonWidth, buttonHeight));
        JPanel buttonPanel = new JPanel(new BorderLayout());
        buttonPanel.setMaximumSize(new Dimension(buttonWidth, buttonHeight));
        buttonPanel.add(button, BorderLayout.CENTER);
        panel.add(buttonPanel);
        return button;
    }

    // Canvas Methods
    private static void addClassButtonClicked(AppCanvasPanel canvasPanel) {
        CanvasClassCard classCard = new CanvasClassCard();
        Dimension screenSize = canvasPanel.getCanvasScreenSize();
        classCard.setBounds(screenSize.width / 2 - 100, screenSize.height / 2 - 112, 200, 225);
        canvasPanel.addComponent(classCard);
    }

    public static void configureToolPanel(Container pane, AppCanvasPanel canvasPanel) {
        JPanel toolPanel = new JPanel();
        toolPanel.setBackground(Color.LIGHT_GRAY);
        toolPanel.setLayout(new BoxLayout(toolPanel, BoxLayout.Y_AXIS)); // Set layout to BoxLayout with Y_AXIS alignment
        toolPanel.setPreferredSize(new Dimension(230, 0));

        toolPanel.add(Box.createVerticalStrut(8)); // give some top space

        JButton addClassButton = addToolButton(toolPanel, "Add Class", "Images/Icons/folder.png");
        addClassButton.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                System.out.println("Add Class button clicked");
                addClassButtonClicked(canvasPanel);
            }
        });
        toolPanel.add(Box.createVerticalStrut(5));
        JButton addDepButton = addToolButton(toolPanel, "Add Dependency", "Images/Icons/arrow.png");
        addDepButton.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                System.out.println("Add Dependency button clicked");
            }
        });
        toolPanel.add(Box.createVerticalStrut(5));
        JButton addNoteButton = addToolButton(toolPanel, "Add Note", "Images/Icons/note.png");
        addNoteButton.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                System.out.println("Add Note button clicked");
            }
        });

        toolPanel.add(Box.createVerticalGlue()); // Add some space between buttons and the bottom buttons

        /*JButton editCanvasButton = addToolButton(toolPanel, "Edit Canvas", "Images/Icons/pen.png");
        editCanvasButton.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                System.out.println("Edit Canvas button clicked");
            }
        });
        toolPanel.add(Box.createVerticalStrut(5));*/
        JButton cleanCanvasButton = addToolButton(toolPanel, "Clean Canvas", "Images/Icons/trash.png");
        cleanCanvasButton.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                System.out.println("Clean Canvas button clicked");
            }
        });

        toolPanel.add(Box.createVerticalStrut(8)); // give some bottom space

        pane.add(toolPanel, BorderLayout.WEST);
    }
}