package lib;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/superAdminActivities")
public class SuperAdminActivities extends HttpServlet {

	public void doPost(HttpServletRequest req, HttpServletResponse res) {
		try {			
			int choice = Integer.parseInt(req.getParameter("service"));
			String redirectUrl = "";
			switch (choice) {
				case 1: 
					redirectUrl = "BookOperations/AddBook.jsp";
					break;
					
				case 2:
					redirectUrl = "BookOperations/EditBook.jsp";
					break;
					
				case 3:
					redirectUrl = "BookOperations/DeleteBook.jsp";
					break;
					
				case 4:
					redirectUrl = "BookOperations/FilterBooks.jsp";
					break;
					
				case 5:
					redirectUrl = "ExportOperations/Export.jsp";
					break;
					
				case 6:
					redirectUrl = "ExportOperations/DeleteExport.jsp";
					break;
					
				case 7:
					redirectUrl = "CustomerOperations/AddCustomer.jsp";
					break;
					
				case 8:
					redirectUrl = "CustomerOperations/DeleteCustomer.jsp";
					break;
					
				case 9:
					redirectUrl = "OrderOperations/OrderBook.jsp";
					break;
					
				case 10:
					redirectUrl = "OrderOperations/FilterDate.jsp";
					break;
					
				case 11:
					redirectUrl = "BookOperations/AllBooks.jsp";
					break;
					
				case 12:
					redirectUrl = "CustomerOperations/AllCustomers.jsp";
					break;
					
				case 13:
					redirectUrl = "OrderOperations/AllOrders.jsp";
					break;
					
			}
			res.sendRedirect("http://localhost:8080/Library%20Management%20Web/webapp/" + redirectUrl);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
