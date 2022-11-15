package drop;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dropBox/logout")
public class Logout extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res) {
        try {
            req.getSession().removeAttribute("currentUser");
            req.getSession().removeAttribute("accessToken");
            res.sendRedirect("http://localhost:8080/Library/webapp/Users/Customer/Customer.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
