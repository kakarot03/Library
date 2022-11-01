package lib;

import java.sql.Connection;
import java.sql.Statement;
import java.io.PrintWriter;
import java.util.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/userLogin")
public class UserLogin extends HttpServlet{

	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		try {
			Connection conn = ConnectionProvider.getConnection();
			if (conn == null) {
				conn = ConnectionProvider.createConnection();
			}
			DBOperations.conn = conn;
			Statement stmt = conn.createStatement();
			stmt.execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255) UNIQUE, password VARCHAR(255) NOT NULL)");
			stmt.execute("ALTER TABLE users AUTO_INCREMENT = 221");
			stmt.execute("INSERT IGNORE INTO users (username, password) VALUES ('super_admin', '12345')");
			String role = req.getParameter("role");
			int choice = role.equalsIgnoreCase("superadmin") ? 1 : role.equalsIgnoreCase("admin") ? 2 : 3;

			String q1 = "CREATE TABLE IF NOT EXISTS user_roles (username VARCHAR(255) PRIMARY KEY, role VARCHAR(255) NOT NULL)";
			String q2 = "INSERT IGNORE INTO user_roles VALUES ('super_admin', 'superadmin')";
			String query1 = "CREATE TABLE IF NOT EXISTS books (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255) NOT NULL, author VARCHAR(255) NOT NULL, category VARCHAR(255) NOT NULL, price DECIMAL(10,4) NOT NULL)";
			String query2 = "CREATE TABLE IF NOT EXISTS orders (id INT PRIMARY KEY AUTO_INCREMENT, book_id INT NOT NULL, cust_id INT NOT NULL, order_date DATE NOT NULL, return_date DATE NOT NULL, FOREIGN KEY (book_id) REFERENCES books (id), FOREIGN KEY (cust_id) REFERENCES users (id))";
			String query3 = "ALTER TABLE books AUTO_INCREMENT = 1101";
			String query4 = "ALTER TABLE orders AUTO_INCREMENT = 611";
			stmt.addBatch(q1);
			stmt.addBatch(q2);
			stmt.addBatch(query1);
			stmt.addBatch(query2);
			stmt.addBatch(query3);
			stmt.addBatch(query4);
			stmt.executeBatch();

			String redirectUrl = "UserPanel.jsp", currentUser = "";
			switch (choice) {
				case 1: 
					currentUser = "superadmin";
					redirectUrl = "Users/SuperAdmin/SuperAdmin.jsp";
					break;
					
				case 2:
					currentUser = "admin";
					redirectUrl = "Users/Admin/Admin.jsp";
					break;
					
				case 3:
					req.getSession().setAttribute("currentUser", "customer");
					res.sendRedirect("http://localhost:8080/Library/index.html");
					return;
			}
			req.getSession().setAttribute("currentUser", currentUser);
			res.sendRedirect("http://localhost:8080/Library/webapp/" + redirectUrl);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) {
		String str = (String)req.getSession().getAttribute("currentUser");
		String redirectUrl = "UserPanel.jsp";
		if(str.equals("superadmin")) {
			redirectUrl = "Users/SuperAdmin/SuperAdmin.jsp";
		} else if(str.equals("admin")) {
			redirectUrl = "Users/Admin/Admin.jsp";
		} else {
			redirectUrl = "Users/Customer/Customer.jsp";
		}
		try {
			res.sendRedirect("http://localhost:8080/Library/webapp/" + redirectUrl);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
