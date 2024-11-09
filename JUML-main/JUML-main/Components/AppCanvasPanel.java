package Components;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class AppCanvasPanel {
    private static final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
    private JPanel umlPanel = new JPanel();

    public AppCanvasPanel() {
        super();
    }

    public AppCanvasPanel(Container pane) {
        umlPanel.setBackground(Color.WHITE);
        umlPanel.setLayout(null); // Set layout manager to null for absolute positioning
        umlPanel.setPreferredSize(new Dimension(screenSize.width, screenSize.height));
        
        // Create a JScrollPane and add the canvas panel to it
        JScrollPane scrollPane = new JScrollPane(umlPanel);
        scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

        // canvas need to have coordinates to be able to scroll
        scrollPane.setLayout(new ScrollPaneLayout());
        scrollPane.getViewport().setScrollMode(JViewport.SIMPLE_SCROLL_MODE);
        scrollPane.getViewport().setViewPosition(new Point(0, 0));
        scrollPane.getViewport().setViewSize(new Dimension(screenSize.width, screenSize.height));

        pane.add(scrollPane, BorderLayout.CENTER);
    }

    // Getters/Setters
    public void addComponent(Component component) {
        umlPanel.add(component);
        // Make the component draggable
        component.addMouseMotionListener(createMouseMotionListener(component, umlPanel));
        // refresh the panel
        umlPanel.revalidate();
        umlPanel.repaint();
    }

    public void removeComponent(Component component) {
        umlPanel.remove(component);
    }

    // createMouseMotionListener
    public static MouseMotionListener createMouseMotionListener(Component component, JPanel umlPanel) {
        return new MouseMotionListener() {
            int x, y;

            @Override
            public void mouseDragged(MouseEvent e) {
                int newX = component.getX() + e.getX() - x;
                int newY = component.getY() + e.getY() - y;
                
                // Check if the new position is within bounds
                if (newX >= 0 && newY >= 0 && newX + component.getWidth() <= umlPanel.getWidth() && newY + component.getHeight() <= umlPanel.getHeight()) {
                    component.setLocation(newX, newY);
                }
            }

            @Override
            public void mouseMoved(MouseEvent e) {
                x = e.getX();
                y = e.getY();
            }
        };
    }

    public Dimension getCanvasSize() {
        return umlPanel.getSize();
    }

    public void setCanvasSize(Dimension dimension) {
        umlPanel.setPreferredSize(dimension);
    }

    public void setCanvasBackground(Color color) {
        umlPanel.setBackground(color);
    }
    
    public void setCanvasLayout(LayoutManager layout) {
        umlPanel.setLayout(layout);
    }

    public Dimension getCanvasScreenSize() {
        return screenSize;
    }
}