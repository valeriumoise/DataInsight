import javax.swing.*;
import java.awt.*;

public class Functions extends JPanel {
    private JTextField columnName;
    private JTextField tableName;
    private JTextField paramFirst;
    private JTextField paramSecond;
    private JButton button;
    private GridBagConstraints constraints;
    private int line;




    public Functions(String table, String column, String firstParam, String secondParam, String buttonName, GridBagConstraints constraints, int line)
    {
        if(!table.equals(""))
            tableName=new JTextField(table);
        else
            tableName=new JTextField("-");
        if(!column.equals(""))
            columnName=new JTextField(column);
        else
            columnName=new JTextField("-");
        if(!firstParam.equals(""))
            paramFirst=new JTextField(firstParam);
        else
            paramFirst=new JTextField("-");
        if(!secondParam.equals(""))
            paramSecond=new JTextField(secondParam);
        else
            paramSecond=new JTextField("-");
        this.constraints=constraints;
        this.line=line;
        button=new JButton(buttonName);
        button.setPreferredSize(new Dimension(200,40));
        columnName.setBackground(Color.CYAN);
        tableName.setBackground(Color.CYAN);
        paramFirst.setBackground(Color.CYAN);
        paramSecond.setBackground(Color.CYAN);
        columnName.setPreferredSize(new Dimension(120, 30));
        tableName.setPreferredSize(new Dimension(120, 30));
        paramFirst.setPreferredSize(new Dimension(120, 30));
        paramSecond.setPreferredSize(new Dimension(120, 30));

    }

    public JTextField getColumnName() {
        return columnName;
    }

    public void setColumnName(JTextField columnName) {
        this.columnName = columnName;
    }

    public JTextField getTableName() {
        return tableName;
    }

    public void setTableName(JTextField tableName) {
        this.tableName = tableName;
    }

    public JTextField getParamFirst() {
        return paramFirst;
    }

    public void setParamFirst(JTextField paramFirst) {
        this.paramFirst = paramFirst;
    }

    public JTextField getParamSecond() {
        return paramSecond;
    }

    public void setParamSecond(JTextField paramSecond) {
        this.paramSecond = paramSecond;
    }

    public JButton getButton() {
        return button;
    }

    public void setButton(JButton button) {
        this.button = button;
    }

    public GridBagConstraints getConstraints() {
        return constraints;
    }

    public void setConstraints(GridBagConstraints constraints) {
        this.constraints = constraints;
    }

    public int getLine() {
        return line;
    }

    public void setLine(int line) {
        this.line = line;
    }
}
