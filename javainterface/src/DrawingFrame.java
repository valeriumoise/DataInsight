import javax.swing.*;
import java.awt.*;

public class DrawingFrame extends JFrame {
    private Toolbar toolbar;
    private Canvas canvas;


    public DrawingFrame() {
        super("Data Insight");
        toolbar=new Toolbar(this);
        canvas =new Canvas(this);

        init();
    }

    private void init(){
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        this.setSize(800, 600);
        this.add(toolbar, BorderLayout.NORTH);
        this.add(canvas);

        this.setVisible(true);
    }

    public Toolbar getToolbar()
    {
        return toolbar;
    }
    public Canvas getCanvas()
    {
        return canvas;
    }

}
