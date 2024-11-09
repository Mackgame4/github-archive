package Classes;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Polygon;

public class DrawComponent {
    public static void drawArrow(Graphics g, int x1, int y1, int x2, int y2) {
        Graphics2D g2d = (Graphics2D) g;
        // draws a tail line
        g2d.drawLine(x1, y1, x2, y2);

        // Calculate angle between the line and the x-axis
        double angle = Math.atan2(y2 - y1, x2 - x1);

        // Length of the arrowhead
        int arrowLength = 10;

        // Angle offset to the arrowhead
        double arrowAngleOffset = Math.toRadians(30); // Adjust as needed

        // Calculate arrowhead points
        int x3 = (int) (x2 - arrowLength * Math.cos(angle - arrowAngleOffset));
        int y3 = (int) (y2 - arrowLength * Math.sin(angle - arrowAngleOffset));
        int x4 = (int) (x2 - arrowLength * Math.cos(angle + arrowAngleOffset));
        int y4 = (int) (y2 - arrowLength * Math.sin(angle + arrowAngleOffset));

        // draws an arrow head
        int[] xPoints = {x2, x3, x4};
        int[] yPoints = {y2, y3, y4};
        Polygon arrowHead = new Polygon(xPoints, yPoints, 3);
        g2d.fill(arrowHead);
    }
}
