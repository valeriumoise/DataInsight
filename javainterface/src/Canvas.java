import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;


public class Canvas extends JPanel {
        private final DrawingFrame frame;
        private Functions formatRegexp;
        private Functions formatRegexpIN;
        private Functions mergeDuplicates;
        private Functions adjustCapitalCase;
        private Functions removeDuplicates;
        private Functions removeWhiteSpaces;

        public Canvas(DrawingFrame frame) {
            super();
            this.frame=frame;
            init();
        }
        public void init()
        {
            this.setBackground(Color.white);
            this.setLayout(new GridBagLayout());
            GridBagConstraints constraints = new GridBagConstraints();
            constraints.anchor = GridBagConstraints.WEST;
            constraints.insets = new Insets(10, 10, 10, 10);
            formatRegexp=new Functions("Table Name", "Column Name", "RegExp",
                    "Update with", "RegExp Format Complete", constraints, 0);
            formatRegexpIN=new Functions("Table Name", "Column Name", "RegExp",
                    "Update with", "RegExp Format Intern", constraints, 1);
            mergeDuplicates=new Functions("Table Name", "", "",
                    "", "Merge Duplicates", constraints, 2);
            adjustCapitalCase=new Functions("Table Name", "Column name", "",
                    "", "Adjust Capital Case", constraints, 3);
            removeDuplicates=new Functions("Table Name", "", "",
                    "", "Remove Duplicates", constraints, 4);
            removeWhiteSpaces=new Functions("Table Name", "", "",
                    "", "Remove White Spaces", constraints, 5);
            addInFrame(formatRegexp, constraints);
            addInFrame(formatRegexpIN, constraints);
            addInFrame(mergeDuplicates, constraints);
            addInFrame(adjustCapitalCase, constraints);
            addInFrame(removeDuplicates, constraints);
            addInFrame(removeWhiteSpaces, constraints);
            JButton newButton=removeWhiteSpaces.getButton();
            newButton.addActionListener(this::removeWhiteSpacesF);
            removeWhiteSpaces.setButton(newButton);
            newButton=formatRegexp.getButton();
            newButton.addActionListener(this::formRegexp);
            formatRegexp.setButton(newButton);
            newButton=formatRegexpIN.getButton();
            newButton.addActionListener(this::formRegexpIN);
            formatRegexpIN.setButton(newButton);
            newButton=adjustCapitalCase.getButton();
            newButton.addActionListener(this::capitalCase);
            adjustCapitalCase.setButton(newButton);
            newButton=removeDuplicates.getButton();
            newButton.addActionListener(this::remDuplicates);
            removeDuplicates.setButton(newButton);
            newButton=mergeDuplicates.getButton();
            newButton.addActionListener(this::doMergeDuplicates);
            mergeDuplicates.setButton(newButton);
        }

    private void removeWhiteSpacesF(ActionEvent e) {

        String call = "{call REMOVE_WHITE_SPACE(?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + removeWhiteSpaces.getTableName().getText());
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void capitalCase(ActionEvent e) {

        String call = "{call MAKE_COL_CAPITAL_CASE(?,?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + adjustCapitalCase.getTableName().getText());
            stmt.setString(2, adjustCapitalCase.getColumnName().getText());
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void remDuplicates(ActionEvent e) {

        String call = "{call REMOVE_DUPLICATES(?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + removeDuplicates.getTableName().getText());
            //stmt.setString(2, "strlist("+removeDuplicates.getParamFirst().getText()+")");
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void doMergeDuplicates(ActionEvent e) {

        String call = "{call MERGE_DUPLICATES(?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + mergeDuplicates.getTableName().getText());
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void formRegexp(ActionEvent e) {

        String call = "{call REGEX_UPDATE_WITH(?,?,?,?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + formatRegexp.getTableName().getText());
            stmt.setString(2, formatRegexp.getColumnName().getText());
            stmt.setString(3, formatRegexp.getParamFirst().getText());
            stmt.setString(4,formatRegexp.getParamSecond().getText());
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void formRegexpIN(ActionEvent e) {

        String call = "{call REGEX_UPDATE_IN_COL(?,?,?,?)}";
        Connection dbConnection=frame.getToolbar().getDatabase().getConnection();
        try (CallableStatement stmt = dbConnection.prepareCall(call)) {
            stmt.setString(1, frame.getToolbar().getDatabase().getUSER() + "." + formatRegexpIN.getTableName().getText());
            stmt.setString(2, formatRegexpIN.getColumnName().getText());
            stmt.setString(3, formatRegexpIN.getParamFirst().getText());
            stmt.setString(4,formatRegexpIN.getParamSecond().getText());
            //System.out.println(removeWhiteSpaces.getTableName().getText());
            stmt.execute();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        try {
            dbConnection.commit();
        } catch (SQLException ex) {

        }
    }

    private void addInFrame(Functions function, GridBagConstraints constraints)
        {
            constraints.gridy=function.getLine();
            constraints.gridx=0;
            this.add(function.getButton(),constraints);
            if(!function.getTableName().getText().equals("-"))
            {
                constraints.gridx=1;
                this.add(function.getTableName(),constraints);
            }
            if(!function.getColumnName().getText().equals("-"))
            {
                constraints.gridx=2;
                this.add(function.getColumnName(),constraints);
            }
            if(!function.getParamFirst().getText().equals("-"))
            {
                constraints.gridx=3;
                this.add(function.getParamFirst(),constraints);
            }
            if(!function.getParamSecond().getText().equals("-"))
            {
                constraints.gridx=4;
                this.add(function.getParamSecond(),constraints);
            }
        }


}
