package Components;

import javax.swing.JButton;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;

public class CanvasClassCard extends JButton { // instead of extending JButton, we can extend JPanel
    private String className = "<class name>";
    private String[] attributes = {"+ <public attribute>: (type)", "# <protected attribute>: (type)", "- <private attribute>: (type)"};
    private String[] methods = {"+ <public method>(parameters)", "# <protected method>(parameters)", "- <private method>(parameters)"};

    public CanvasClassCard() {
        setPreferredSize(new Dimension(200, 225));
    }

    public CanvasClassCard(Dimension dimension) {
        setPreferredSize(dimension);
    }

    public void CreateClassCard(String className, String[] attributes, String[] methods) {
        this.className = className;
        this.attributes = attributes;
        this.methods = methods;
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;

        // Draw "<class name>" centered above the splitter
        Font font = new Font("Arial", Font.BOLD, 14); // Set bold font for class name
        g2d.setFont(font);
        FontMetrics metrics = g.getFontMetrics();
        int x = (getWidth() - metrics.stringWidth(className)) / 2;
        int y = 30;
        g.drawString(className, x, y);

        // Draw horizontal line for splitter
        g2d.setColor(Color.BLACK);
        g2d.drawLine(0, 50, getWidth(), 50);

        // For the attributes and methods, use a plain font
        font = new Font("Arial", Font.PLAIN, 13);
        g2d.setFont(font);

        // Draw attributes
        int yAttribute = 80;
        for (String attribute : attributes) {
            yAttribute = drawStringWithSplit(g, attribute, 10, yAttribute, getWidth() - 20);
        }

        // Draw horizontal line for splitter
        g2d.drawLine(0, yAttribute, getWidth(), yAttribute);

        // Draw methods
        int yMethod = yAttribute + 30;
        for (String method : methods) {
            yMethod = drawStringWithSplit(g, method, 10, yMethod, getWidth() - 20);
        }

        // Set preferred height to the last y position (later when we add more attributes and methods, we can adjust the height of the class card accordingly)
        /*setPreferredSize(new Dimension(getWidth(), yMethod));
        revalidate();*/
    }

    private int drawStringWithSplit(Graphics g, String text, int x, int y, int maxWidth) {
        FontMetrics metrics = g.getFontMetrics();
        int lineHeight = metrics.getHeight();
        int textWidth = metrics.stringWidth(text);
        
        // Check if the text fits within the available width
        if (textWidth <= maxWidth) {
            g.drawString(text, x, y);
            return y + lineHeight; // Return the next y position
        } else {
            // If the text exceeds the width, split it and draw on multiple lines
            int numChars = text.length();
            int start = 0;
            while (start < numChars) {
                int end = start;
                while (end < numChars && metrics.stringWidth(text.substring(start, end + 1)) <= maxWidth) {
                    end++;
                }
                g.drawString(text.substring(start, end), x, y);
                start = end + 1;
                y += lineHeight;
            }
            return y; // Return the next y position
        }
    }
}
