package drop;

import drop.Credentials;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dropbox.core.DbxException;
import com.dropbox.core.InvalidAccessTokenException;
import com.dropbox.core.util.IOUtil.ProgressListener;
import com.dropbox.core.v2.DbxClientV2;
import com.dropbox.core.v2.files.DbxUserListFolderBuilder;
import com.dropbox.core.v2.files.DeleteErrorException;
import com.dropbox.core.v2.files.FileMetadata;
import com.dropbox.core.v2.files.ListFolderErrorException;
import com.dropbox.core.v2.files.ListFolderResult;
import com.dropbox.core.v2.files.Metadata;
import com.dropbox.core.v2.files.UploadErrorException;
import com.dropbox.core.v2.files.WriteMode;

import lib.DBOperations;

@WebServlet("/dropBox/main")
public class Main extends HttpServlet {

    static DbxClientV2 client = null;
    private static final String booksPath = "C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Downloads\\";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession().getAttribute("accessToken") == null) {
            resp.sendRedirect("http://localhost:8080/Library/dropBox/authStart");
            return;
        }

        client = new DbxClientV2(Credentials.getRequestConfig(),
                (String) req.getSession().getAttribute("accessToken"));

        try {
            String user = client.users().getCurrentAccount().getName().getDisplayName();
            req.getSession().setAttribute("currentUser", user);
        } catch (InvalidAccessTokenException e) {
            System.out.println("Access Token Expired!");
            req.getSession().removeAttribute("accessToken");
            DBOperations.removeAccessToken((String) req.getSession().getAttribute("user"));
            resp.sendRedirect("http://localhost:8080/Library/dropBox/authStart");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("http://localhost:8080/Library/webapp/Users/Customer/DropBox/dropBox.jsp");
    }

    public static String getUserName() throws Exception {
        return client.users().getCurrentAccount().getName().getDisplayName();
    }

    public static void uploadFile(String filePath, String dropboxPath)
            throws IOException, UploadErrorException, DbxException, Exception {

        File file = new File(filePath);
        InputStream in = new FileInputStream(file);
        ProgressListener progressListener = l -> printProgress(l, file.length());

        FileMetadata metadata = client.files().uploadBuilder(dropboxPath)
                .withMode(WriteMode.ADD)
                .withClientModified(new Date(file.lastModified()))
                .uploadAndFinish(in, progressListener);

        System.out.println("\n" + metadata.toStringMultiline());
    }

    public static int uploadAllBooks(String customer) {
        int count = 0;
        String dest = "/" + customer + "/Books/";
        try {
            ResultSet rs = DBOperations.allOrders(DBOperations.findUserId(customer));
            while (rs.next()) {
                DBOperations.exportBook(DBOperations.getBook(rs.getInt(1)));
                uploadFile("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\" + rs.getInt(1) + ".txt",
                        dest + rs.getInt(1) + ".txt");
                count++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public static void uploadBook(int id, String username) throws Exception {
        String dest = "/" + username + "/Books/";
        if (!DBOperations.checkCustomerPurchase(id, DBOperations.findUserId(username))) {
            throw new RuntimeException("Invalid BookId");
        }
        DBOperations.exportBook(DBOperations.getBook(id));
        uploadFile("C:\\apache-tomcat-9.0.67\\webapps\\Library\\Files\\Books\\" + id + ".txt", dest);
    }

    private static void printProgress(long uploaded, long size) {
        System.out.printf("Uploaded %12d / %12d bytes (%5.2f%%)\n", uploaded, size, 100 * (uploaded / (double) size));
    }

    public static void downloadFile(String path, String username) throws IOException, DbxException {
        String destinationFile = booksPath + "\\" + path.substring(path.lastIndexOf("/") + 1);
        File file = new File(destinationFile);
        if (!file.exists()) {
            file.createNewFile();
        }
        OutputStream downloadFile = new FileOutputStream(file);
        try {
            FileMetadata metadata = client.files().downloadBuilder(path)
                    .download(downloadFile);
            System.out.println("Downloaded");
        } finally {
            downloadFile.close();
        }

    }

    public static void deleteFile(String path) throws DbxException, DeleteErrorException {
        client.files().deleteV2(path);
    }

    public static HashMap<String, String> getFilesList() throws ListFolderErrorException, DbxException {

        DbxUserListFolderBuilder listFolderBuilder = client.files().listFolderBuilder("");
        ListFolderResult result = listFolderBuilder.withRecursive(true).start();

        HashMap<String, String> filesList = new HashMap<>();

        while (true) {
            if (result != null) {
                for (Metadata entry : result.getEntries()) {
                    if (entry instanceof FileMetadata) {
                        filesList.put(entry.getName(), entry.getPathLower());
                    }
                }

                if (!result.getHasMore()) {
                    return filesList;
                }

                try {
                    result = client.files().listFolderContinue(result.getCursor());
                } catch (DbxException e) {
                    System.out.println("\nCouldn't get listFolderContinue");
                }
            }
        }
    }
}
