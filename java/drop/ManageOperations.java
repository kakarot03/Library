package drop;

import drop.Main;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dropBox/manage")
public class ManageOperations extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int action = Integer.parseInt(req.getParameter("action"));
        String success = "?status=success",
                redirect = "http://localhost:8080/Library/webapp/Users/Customer/DropBox/UploadFile.jsp";

        switch (action) {
            case 1:
                // Uploading new File
                String filePath = req.getParameter("path1");
                String dropBoxPath = req.getParameter("path2");
                if (!filePath.isBlank() && !dropBoxPath.isBlank()) {
                    try {
                        Main.uploadFile(filePath, dropBoxPath);
                        resp.sendRedirect(redirect + success + "&msg=File Uploaded Successfully");
                    } catch (IOException e) {
                        resp.sendRedirect(redirect + "?status=fail&msg=Local File Path is Invalid");
                    } catch (Exception e) {
                        resp.sendRedirect(redirect + "?status=fail&msg=Upload Path is Invalid");
                    }
                    break;
                }

                // Uploading Book
                String prop = req.getParameter("bookProp");
                String user = (String) req.getSession().getAttribute("user");
                int value = Integer.parseInt(prop);
                if (value == 1) {
                    int count = Main.uploadAllBooks(user);
                    if (count == 0) {
                        resp.sendRedirect(redirect + "?status=fail&msg=You have no Books purchased");
                    } else {
                        resp.sendRedirect(redirect + success + "&msg=Uploaded " + count
                                + " book(s) to DropBox&path/" + user + "Books/");
                    }
                } else {
                    try {
                        Main.uploadBook(Integer.parseInt(req.getParameter("bookId")), user);
                        resp.sendRedirect(
                                redirect + success + "&msg=Uploaded the book to DropBox&path=/" + user + "Books/");
                    } catch (RuntimeException e) {
                        resp.sendRedirect(redirect + "?status=fail&msg=Invalid Book Id");
                    } catch (Exception e) {
                        resp.sendRedirect(redirect + "?status=fail&msg=Upload failed, Try again");
                    }
                }
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        int action = Integer.parseInt(req.getParameter("action"));
        String success = "?status=success",
                redirect = "http://localhost:8080/Library/webapp/Users/Customer/DropBox/dropBox.jsp";

        switch (action) {
            case 1:
                String filePath = req.getParameter("file");
                try {
                    Main.downloadFile(filePath, (String) req.getSession().getAttribute("user"));
                    resp.sendRedirect(redirect + success + "&msg=File Downloaded Successfully");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect(redirect + "?status=fail&msg=Error downloading the file");
                }
                break;

            case 2:
                filePath = req.getParameter("file");
                try {
                    Main.deleteFile(filePath);
                    resp.sendRedirect(redirect + success + "&msg=File Deleted Successfully");
                } catch (Exception e) {
                    resp.sendRedirect(redirect + "?status=fail&msg=Error deleting the file");
                }
                break;
        }
    }
}
