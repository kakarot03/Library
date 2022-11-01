package lib;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.File;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.sql.PreparedStatement;

public class DBOperations {

    static Connection conn;
    static BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

    static {
        conn = ConnectionProvider.createConnection();
    }

    static public void newBook(String name, String author, int cat, float price) throws Exception {
        String s = "";
        switch (cat) {
            case 1:
                s = "History";
                break;
            case 2:
                s = "Biographies";
                break;
            case 3:
                s = "Medical";
                break;
            case 4:
                s = "Comics";
                break;
            case 5:
                s = "Literature";
                break;
            default:
                s = "-";
        }
        String query = "INSERT INTO books (name, author, category, price) values (?, ?, ?, ?)";
        PreparedStatement preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1, titleCase(name));
        preparedStmt.setString(2, titleCase(author));
        preparedStmt.setString(3, s);
        preparedStmt.setString(4, price + "");
        preparedStmt.execute();
    }

    static public void deleteBook(int id) throws Exception {
        String query1 = "DELETE FROM orders WHERE book_id = " + id;
        String query2 = "DELETE FROM books WHERE id = " + id;
        Statement stmt = conn.createStatement();
        stmt.addBatch(query1);
        stmt.addBatch(query2);
        stmt.executeBatch();
        deleteExport(id);
    }

    static public void editBook(Book b, int choice, String val) throws Exception {
        String query;
        switch (choice) {
            case 1:
                query = "UPDATE books SET name = '" + titleCase(val) + "' WHERE id = " + b.getId();
                break;
            case 2:
                query = "UPDATE books SET author = '" + titleCase(val) + "' WHERE id = " + b.getId();
                break;
            case 3:
                String s;
                switch (Integer.parseInt(val)) {
                    case 1:
                        s = "History";
                        break;
                    case 2:
                        s = "Biographies";
                        break;
                    case 3:
                        s = "Medical";
                        break;
                    case 4:
                        s = "Comics";
                        break;
                    case 5:
                        s = "Literature";
                        break;
                    default:
                        s = "-";
                }
                query = "UPDATE books SET category = '" + s + "' WHERE id = " + b.getId();
                break;
            case 4:
                query = "UPDATE books SET price = " + Float.parseFloat(val.trim()) + " WHERE id = " + b.getId();
                break;
            default:
                System.out.println("\nInvalid Choice!");
                return;
        }

        Statement stmt = conn.createStatement();
        stmt.executeUpdate(query);
        System.out.println("\nBook Updated Successfully!");
    }

    static public ResultSet searchBook(int choice, String val, String pri) throws Exception {

        String query = "";
        Statement stmt = conn.createStatement();
        switch (choice) {
            case 1:
                query = "SELECT * FROM books WHERE name LIKE '" + val + "%'";
                break;
            case 3:
                int cat = Integer.parseInt(val);
                String category;
                switch (cat) {
                    case 1:
                        category = "History";
                        break;
                    case 2:
                        category = "Biography";
                        break;
                    case 3:
                        category = "Medical";
                        break;
                    case 4:
                        category = "Comics";
                        break;
                    case 5:
                        category = "Literature";
                        break;
                    default:
                        category = "-";
                }
                query = "SELECT * FROM books WHERE category = '" + category + "'";
                break;
            case 2:
                query = "SELECT * FROM books WHERE author = '" + val + "'";
                break;
            case 4:
                float low = Float.parseFloat(val);
                float high = Float.parseFloat(pri);
                query = "SELECT * FROM books WHERE price BETWEEN " + low + " AND " + high;
                break;
            default:
                System.out.println("\nInvalid Input!");
        }
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    static public ResultSet displayAllBooks() throws Exception {

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM books");
        return rs;
    }

    static public void exportBook(Book b) throws Exception {

        File file = new File("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\" + b.getId() + ".txt");
        if (file.createNewFile()) {
            FileWriter writer = new FileWriter(file);
            writer.write(String.format("\t\t\t%-15s :  %s\n\t\t\t%-15s :  %s\n\t\t\t%-15s :  %s\n\t\t\t%-15s :  %s\n\t\t\t%-15s :  %.4f", "Book Id", b.getId(), "Name", b.getName(), "Author", b.getAuthor(), "Category", b.getCategory(), "Price", b.getPrice()));
            writer.close();
        }

        System.out.println("\nBook exported successfully");
    }

    static public void exportAllBooks() throws Exception {
        Statement stmt = conn.createStatement();
        String query = "SELECT * FROM books";
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {
            exportBook(new Book(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getFloat(5)));
        }
    }

    static public void deleteExport(int id) throws Exception {
        File file = new File("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\" + id + ".txt");
        file.delete();
    }

    static public void deleteAllExport() throws Exception {
        File file = new File("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\");
        for (File subFile : file.listFiles()) {
            subFile.delete();
        }
    }

    static public boolean findUser(int id) throws Exception {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE id = " + id);
        return rs.next();
    }
	
	static public boolean findUser(String name) throws Exception {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE username = '" + name + "'");
        return rs.next();
    }
	
	static public boolean validatePassword(String name, String pass) throws Exception {
		Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE username = '" + name + "'");
        return rs.next() ? rs.getString("password").equals(pass) : false;
	}

    static public int findUserRole(String name) throws Exception {
        Statement stmt = conn.createStatement();
        ResultSet rs;
        try {
            rs = stmt.executeQuery("SELECT role FROM user_roles WHERE username = '" + name + "'");   
        } catch(SQLSyntaxErrorException e) {
            return -1;
        }
        if (!rs.next())
            return -1;
        String role = rs.getString(1).toLowerCase();
        return role.equals("superadmin") ? 1 : (role.equals("admin") ? 2 : role.equals("customer") ? 3 : -1);
    }

    static public void addUser(String name, String pass, String role) throws Exception {
        String query = "INSERT INTO users (username, password) values (?, ?)";
        PreparedStatement preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1, name);
        preparedStmt.setString(2, pass);
        preparedStmt.execute();
        query = "INSERT INTO user_roles (username, role) values (?, ?)";
        preparedStmt = conn.prepareStatement(query);
        preparedStmt.setString(1, name);
        preparedStmt.setString(2, role);
        preparedStmt.execute();
    }

    static public void deleteUser(int id) throws Exception {
        String query1 = "DELETE FROM orders WHERE cust_id = " + id;
        String query2 = "DELETE FROM users WHERE id = " + id;
        String query3 = "DELETE FROM user_roles WHERE username = '" + getUserName(id) + "'";
        Statement stmt = conn.createStatement();
        stmt.addBatch(query1);
        stmt.addBatch(query2);
        stmt.addBatch(query3);
        stmt.executeBatch();
    }

    static public void orderBook(int bId, int cId, String d1, String d2) throws Exception {
        String query = "INSERT INTO orders (book_id, cust_id, order_date, return_date) values (?, ?, ?, ?)";
        PreparedStatement preparedStmt = conn.prepareStatement(query);
        preparedStmt.setInt(1, bId);
        preparedStmt.setInt(2, cId);
        preparedStmt.setString(3, d1);
        preparedStmt.setString(4, d2);
        preparedStmt.execute();
    }

    static public String getUserName(int id) throws Exception {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT username FROM users WHERE id = " + id);
        return rs.next() ? rs.getString(1) : "";
    }

    static public ResultSet orderDetails() throws Exception {
        Statement stmt = conn.createStatement();
        String query = "SELECT * FROM orders";
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    static public boolean isValidDate(String d1, String d2) {
        d1 = d1.replaceAll("-", "/");
        d2 = d2.replaceAll("-", "/");
        DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        try {
            LocalDate date1 = LocalDate.parse(d1, format);
            LocalDate date2 = LocalDate.parse(d2, format);
            if (date1.isAfter(date2)) {
                return true;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    static public ResultSet allOrders(int id) throws Exception {
        Statement stmt = conn.createStatement();
        String query = "SELECT t1.id, t2.id, t2.username, t1.name, t1.author, t1.category, t1.price, t3.order_date, t3.return_date FROM BOOKS t1 INNER JOIN users t2 INNER JOIN ORDERS t3 ON t3.cust_id = t2.id AND t3.book_id = t1.id";
        query += id != 0 ? " WHERE t2.id = " + id : "";
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    static public ResultSet filterDate(String date, int choice) throws Exception {
        String query = "SELECT t1.id, t2.id, t2.username, t1.name, t1.author, t1.category, t1.price, t3.order_date, t3.return_date FROM BOOKS t1 INNER JOIN users t2 INNER JOIN ORDERS t3 ON t3.cust_id = t2.id AND t3.book_id = t1.id AND DATEDIFF(t3.return_date, '" + date + "')";
        Statement stmt = conn.createStatement();
        if (choice == 1) {
            query += " <= 0";
        } else if (choice == 2) {
            query += " > 0";
        }
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    static public ResultSet allUsers() throws Exception {
        Statement stmt = conn.createStatement();
        String query = "SELECT t1.id, t1.username, t2.role FROM users t1 INNER JOIN user_roles t2 WHERE t1.username = t2.username ORDER BY t1.id;";
        ResultSet rs = stmt.executeQuery(query);
        return rs;
    }

    static public void terminate() throws Exception {
        File file = new File("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\");
        for (File subFile : file.listFiles()) {
            subFile.delete();
        }

        Statement stmt = conn.createStatement();
        stmt.execute("DROP TABLE IF EXISTS orders");
        stmt.execute("DROP TABLE IF EXISTS books");
        stmt.execute("DROP TABLE IF EXISTS users");
        stmt.execute("DROP TABLE IF EXISTS user_roles");
        System.out.println("DB closed");
        conn.close();
    }

    static public Book fetchBook(int id) throws Exception {
        Statement stmt = conn.createStatement();
        String query = "SELECT * FROM books WHERE id = " + id;
        ResultSet rs = stmt.executeQuery(query);
        Book b = null;
        if (rs.next()) {
            b = new Book(id, rs.getString(2), rs.getString(3), rs.getString(4), rs.getFloat(5));
        }
        return b;
    }

    static public void addUserIfNotExists(String user, String pass) throws Exception {
        pass = pass == null ? "password" : pass;
        if(getUserId(user) == -1) {
            System.out.println("new user");
            addUser(user, pass, "customer");
        }
    }

    static public boolean validatePassword(String password) throws Exception {
        return password.length() >= 5;
    }
    
    static public int lastUserId() throws Exception {
    	ResultSet rs = conn.createStatement().executeQuery("SELECT MAX(id) FROM users");
    	return rs.next() ? rs.getInt(1) : -1;
    }
    
    static public int getUserId(String name) throws Exception {
        ResultSet rs = conn.createStatement().executeQuery("SELECT id FROM users WHERE username = '" + name + "'");
        return rs.next() ? rs.getInt(1) : -1;
    }

    static public int lastBookId() throws Exception {
    	ResultSet rs = conn.createStatement().executeQuery("SELECT MAX(id) FROM books");
    	return rs.next() ? rs.getInt(1) : -1;
    }

    static public String titleCase(String name) {
		if(name == null || name.isEmpty()) return "";
        String res = "";
        for (String s : name.split("\\s+")) {
            res += s.substring(0, 1).toUpperCase() + s.substring(1).toLowerCase() + " ";
        }
        return res.trim();
    }
}