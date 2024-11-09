package Classes;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class ResizableComponent extends JPanel {
    private Component component;
    private JFrame frame;

    public ResizableComponent(Component component, JFrame frame) {
        this.component = component;
        this.frame = frame;
        setLayout(new BorderLayout());
        add(component, BorderLayout.CENTER);

        frame.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                super.componentResized(e);
                resizeComponent();
            }
        });
    }

    private void resizeComponent() {
        Dimension size = frame.getSize();
        int width = size.width / 2;
        int height = size.height;
        component.setPreferredSize(new Dimension(width, height));
        revalidate();
        repaint();
    }

    public Component getComponent() {
        return component;
    }
}