package lib;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/adminActivities")
public class AdminActivities extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		try {
			int choice = Integer.parseInt(req.getParameter("service"));
			String redirectUrl = "";
			switch (choice) {
			case 1:
				redirectUrl = "BookOperations/FilterBooks.jsp";
				break;

			case 2:
				redirectUrl = "BookOperations/AllBooks.jsp";
				break;

			case 3:
				redirectUrl = "CustomerOperations/AllCustomers.jsp";
				break;

			case 4:
				redirectUrl = "OrderOperations/AllOrders.jsp";
				break;
			}
			res.sendRedirect("http://localhost:8080/Library%20Management%20Web/webapp/" + redirectUrl);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
