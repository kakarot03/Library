package jaas;

import lib.DBOperations;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.security.auth.Subject;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;

public class AuthLoginModule implements LoginModule {

  private CallbackHandler handler;
  private Subject subject;
  private UserPrincipal userPrincipal;
  private RolePrincipal rolePrincipal;
  private String login;
  private List<String> userGroups;

  @Override
  public void initialize(Subject subject, CallbackHandler callbackHandler, Map<String, ?> sharedState, Map<String, ?> options) {
    this.handler = callbackHandler;
    this.subject = subject;
  }

  @Override
  public boolean login() throws LoginException {

    Callback[] callbacks = new Callback[2];
    callbacks[0] = new NameCallback("login");
    callbacks[1] = new PasswordCallback("password", true);

    try {
      handler.handle(callbacks);
      String name = ((NameCallback) callbacks[0]).getName();
      String password = String.valueOf(((PasswordCallback) callbacks[1]).getPassword());
	  userGroups = new ArrayList<String>();
	  
	  try {
		  if(DBOperations.findUser(name) && DBOperations.validatePassword(name, password)) {
		    int role = DBOperations.findUserRole(name);
			if(role == 1) {
				userGroups.add("superadmin");
			} else if(role == 2) {
				userGroups.add("admin");
			} else if(role == 3) {
				userGroups.add("customer");
			}
			if(role >= 1 && role <= 3) return true;
		  }  
	  } catch(Exception e) {
		  e.printStackTrace();
	  }
      throw new LoginException("Authentication failed");
    } catch (IOException e) {
      throw new LoginException(e.getMessage());
    } catch (UnsupportedCallbackException e) {
      throw new LoginException(e.getMessage());
    }

  }

  @Override
  public boolean commit() throws LoginException {

    userPrincipal = new UserPrincipal(login);
    subject.getPrincipals().add(userPrincipal);

    if (userGroups != null && userGroups.size() > 0) {
      for (String groupName : userGroups) {
        rolePrincipal = new RolePrincipal(groupName);
        subject.getPrincipals().add(rolePrincipal);
      }
    }

    return true;
  }

  @Override
  public boolean abort() throws LoginException {
    return false;
  }

  @Override
  public boolean logout() throws LoginException {
	System.out.println("logging out...");
    subject.getPrincipals().remove(userPrincipal);
    subject.getPrincipals().remove(rolePrincipal);
    return true;
  }

}