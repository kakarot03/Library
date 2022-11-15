package lib;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;

@WebServlet("/logout1")
public class LogoutHandle extends HttpServlet {

    public void doGet(HttpServletRequest req, HttpServletResponse res) {
        try {
            String flag = req.getParameter("btn"), sess = req.getParameter("session");
            if (flag != null && flag.equals("terminate")) {
                DBOperations.terminate();
            }
            if (sess == null) {
                req.getSession().removeAttribute("status");
            }
            ConnectionProvider.closeConnection();
            req.getSession().invalidate();
            Cookie[] cookies = req.getCookies();
            if (cookies != null)
                for (Cookie cookie : cookies) {
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    res.addCookie(cookie);
                }
            res.sendRedirect("webapp/UserPanel.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
