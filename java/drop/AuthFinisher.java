package drop;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dropbox.core.DbxAuthFinish;
import com.dropbox.core.DbxException;
import com.dropbox.core.DbxSessionStore;
import com.dropbox.core.DbxStandardSessionStore;
import com.dropbox.core.DbxWebAuth;

import drop.Credentials;
import lib.DBOperations;

@WebServlet("/dropBox/authEnd")
public class AuthFinisher extends HttpServlet {

    private DbxWebAuth webAuth = Credentials.getWebAuthObject();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);
        String sessionKey = "dropbox-auth-csrf-token";
        DbxSessionStore csrfTokenStore = new DbxStandardSessionStore(session, sessionKey);

        DbxAuthFinish authFinish;
        try {
            authFinish = webAuth.finishFromRedirect(
                    Credentials.getRedirectURI(), csrfTokenStore, req.getParameterMap());
        } catch (DbxWebAuth.BadRequestException ex) {
            System.out.println("On /dropbox-auth-finish: Bad request: " + ex.getMessage());
            resp.sendError(400);
            return;
        } catch (DbxWebAuth.BadStateException ex) {
            resp.sendRedirect("http://localhost:8080/Library/dropBox/authStart");
            return;
        } catch (DbxWebAuth.CsrfException ex) {
            System.out.println("On /dropbox-auth-finish: CSRF mismatch: " + ex.getMessage());
            resp.sendError(403, "Forbidden.");
            return;
        } catch (DbxWebAuth.NotApprovedException ex) {
            System.out.println("Access not Approved");
            resp.sendRedirect("");
            return;
        } catch (DbxWebAuth.ProviderException ex) {
            System.out.println("On /dropbox-auth-finish: Auth failed: " + ex.getMessage());
            resp.sendError(503, "Error communicating with Dropbox.");
            return;
        } catch (DbxException ex) {
            System.out.println("On /dropbox-auth-finish: Error getting token: " + ex.getMessage());
            resp.sendError(503, "Error communicating with Dropbox.");
            return;
        }

        req.getSession().setAttribute("accessToken", authFinish.getAccessToken());
        try {
            DBOperations.addAccessToken(req);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (req.getSession().getAttribute("requestedURI") != null) {
            resp.sendRedirect((String) req.getSession().getAttribute("requestedURI"));
        } else {
            resp.sendRedirect("http://localhost:8080/Library/dropBox/main");
        }
    }

}
