package drop;

import com.dropbox.core.DbxAppInfo;
import com.dropbox.core.DbxRequestConfig;
import com.dropbox.core.DbxWebAuth;

public class Credentials {

    private static final String APP_KEY = "i6kkth4tmghuivm";
    private static final String APP_SECRET = "tmmuj694dv8v56m";
    private static final String REDIRECT_URI = "http://localhost:8080/Library/dropBox/authEnd";

    private static DbxAppInfo appInfo = new DbxAppInfo(APP_KEY, APP_SECRET);

    private static DbxRequestConfig requestConfig = new DbxRequestConfig(Credentials.class.getSimpleName());
    private static DbxWebAuth webAuth = new DbxWebAuth(requestConfig, appInfo);

    public static String getRedirectURI() {
        return REDIRECT_URI;
    }

    public static DbxWebAuth getWebAuthObject() {
        return webAuth;
    }

    public static DbxAppInfo getAppInfo() {
        return appInfo;
    }

    public static DbxRequestConfig getRequestConfig() {
        return requestConfig;
    }
}
