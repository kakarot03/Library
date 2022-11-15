package lib;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/customerActivities")
public class CustomerActivities extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		try {
			int choice = Integer.parseInt(req.getParameter("service"));
			String redirectUrl = "";
			switch (choice) {
				case 1:
					redirectUrl = "BookOperations/FilterBooks.jsp";
					break;

				case 2:
					req.getSession().setAttribute("cus", req.getSession().getAttribute("cust"));
					req.getSession().setAttribute("opn", 11);
					redirectUrl = "OperationManager.jsp";
					break;
			}
			res.sendRedirect("http://localhost:8080/Library%20Management%20Web/webapp/" + redirectUrl);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
