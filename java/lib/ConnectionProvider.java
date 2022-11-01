package lib;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionProvider {
	
	private static Connection conn;
	
	static {
		createConnection();
	}

	public static Connection createConnection() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/libraryManagement", "sri", "Sri@1104");
		} catch(Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

	public static Connection getConnection() {
		return conn == null ? createConnection() : conn;
	}

	public static void closeConnection() throws Exception {
		if(conn == null) return;
		conn.close();
		conn = null;
	}
}
