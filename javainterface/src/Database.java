import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private String URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private String USER = "STUDENT";
    private String PASSWORD = "STUDENT";
    private static Connection connection = null;
    public Database(String Url, String User, String Password) {
        this.URL=Url;
        this.USER=User;
        this.PASSWORD=Password;
        createConnection(Url,User,Password);
    }
    public static Connection getConnection() {
//        if (connection == null) {
//            createConnection();
//        }
        return connection;
    }
    static void createConnection(String Url, String User, String Password)
    {
        //Connection con = null;
        //System.out.println(Url);

        try {
            connection = DriverManager.getConnection(
                    Url, User, Password);
            connection.setAutoCommit(false);
        } catch(SQLException e) {
            System.err.println("SQLException: " + e);
        }
    }

    public static void commit() {
        try {
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void closeConnection() {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void rollback() {
        try {
            connection.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getURL() {
        return URL;
    }

    public String getUSER() {
        return USER;
    }

    public String getPASSWORD() {
        return PASSWORD;
    }

    public static void setConnection(Connection connection) {
        Database.connection = connection;
    }
}
