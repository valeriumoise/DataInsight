import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;

public class Toolbar extends JPanel {
    private final DrawingFrame frame;
    private JTextField user;
    private JTextField password;
    private JTextField url;
    private JButton connect;
    private JLabel conn;
    private Database database;
    private GridBagConstraints constraints;
    public Toolbar(DrawingFrame frame) {
        this.frame=frame;
        init();
    }
    private void init(){
        url=new JTextField("  Database Connection URL  ");
        user=new JTextField("     USERNAME     ");
        password=new JTextField("     PASSWORD     ");
        JLabel message=new JLabel("Database Connection");
        message.setFocusable(true);
        this.setLayout(new GridBagLayout());
        constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.CENTER;
        constraints.insets = new Insets(10, 10, 10, 10);
        url=costomizeField(url,100);
        user=costomizeField(user, 70);
        password=costomizeField(password, 70);
        constraints.gridx = 1;
        constraints.gridy = 0;
        this.add(message, constraints);
        constraints.gridx = 0;
        constraints.gridy = 1;
        this.add(user, constraints);
        constraints.gridx = 1;
        constraints.gridy = 1;
        this.add(url, constraints);
        constraints.gridx = 2;
        constraints.gridy = 1;
        this.add(password, constraints);
        this.setOpaque(true);
        this.setSize(400, 100);
        this.setBackground(Color.ORANGE);
        this.setBorder(BorderFactory.createLineBorder(Color.red));
        connect = new JButton("Connect");
        constraints.gridx=0;
        constraints.gridy=2;
        this.add(connect,constraints);
        connect.addActionListener(this::makeConnection);
        JLabel status=new JLabel("Status: ");
        constraints.gridx=1;
        constraints.gridy=2;
        this.add(status,constraints);
        conn=new JLabel ("Disconnected");
        constraints.gridx=2;
        constraints.gridy=2;
        this.add(conn,constraints);
    }

    private JTextField costomizeField(JTextField jTextField, int size)
    {
        jTextField.setBackground(Color.YELLOW);
        jTextField.setSize(size, 120);
        Font font=new Font("Arial", Font.CENTER_BASELINE, 12);
        jTextField.setFont(font);
        return jTextField;

    }
    public String getConnectionURL()
    {
        return url.getText();
    }

    public String getUser()
    {
        return user.getText();
    }

    public String getPassword()
    {
        return password.getText();
    }

    private void makeConnection(ActionEvent e)
    {
        this.database=new Database(url.getText(),user.getText(), password.getText());
        this.conn.setText("Connected");
        this.remove(conn);
        constraints.gridx=2;
        constraints.gridy=2;
        this.add(conn, constraints);
    }

    public Database getDatabase() {
        return database;
    }

    public void setDatabase(Database database) {
        this.database = database;
    }
}
