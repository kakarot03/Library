package drop;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dropbox.core.DbxSessionStore;
import com.dropbox.core.DbxStandardSessionStore;
import com.dropbox.core.DbxWebAuth;

import drop.Credentials;
import lib.DBOperations;

@WebServlet("/dropBox/authStart")
public class AuthInitializer extends HttpServlet {

    private DbxWebAuth webAuth = Credentials.getWebAuthObject();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String user = (String) req.getSession().getAttribute("user");
        try {
            String accessToken = DBOperations.getAccessToken(user);
            if (accessToken != null) {
                req.getSession().setAttribute("accessToken", accessToken);
                if (req.getSession().getAttribute("requestedURI") != null) {
                    resp.sendRedirect((String) req.getSession().getAttribute("requestedURI"));
                } else {
                    resp.sendRedirect("http://localhost:8080/Library/dropBox/main");
                }
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            HttpSession session = req.getSession(true);
            String sessionKey = "dropbox-auth-csrf-token";
            DbxSessionStore sessionStore = new DbxStandardSessionStore(session, sessionKey);

            DbxWebAuth.Request webAuthRequest = DbxWebAuth.newRequestBuilder()
                    .withRedirectUri(Credentials.getRedirectURI(), sessionStore)
                    .build();

            String authorizeUrl = webAuth.authorize(webAuthRequest);
            System.out.println("\nAuthorize Url = " + authorizeUrl + "\n");
            resp.sendRedirect(authorizeUrl);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
