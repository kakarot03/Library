package no.steras.opensamlSamples.opensaml4WebprofileDemo.sp;

import java.io.IOException;
import java.security.Provider;
import java.security.Security;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.opensaml.core.config.ConfigurationService;
import org.opensaml.core.config.InitializationException;
import org.opensaml.core.config.InitializationService;
import org.opensaml.core.xml.config.XMLObjectProviderRegistry;
import org.opensaml.messaging.context.MessageContext;
import org.opensaml.messaging.encoder.MessageEncodingException;
import org.opensaml.saml.common.messaging.context.SAMLBindingContext;
import org.opensaml.saml.common.messaging.context.SAMLEndpointContext;
import org.opensaml.saml.common.messaging.context.SAMLPeerEntityContext;
import org.opensaml.saml.common.SAMLObject;
import org.opensaml.saml.common.xml.SAMLConstants;
import org.opensaml.saml.saml2.binding.encoding.impl.HTTPRedirectDeflateEncoder;
import org.opensaml.saml.saml2.core.AuthnContext;
import org.opensaml.saml.saml2.core.AuthnContextClassRef;
import org.opensaml.saml.saml2.core.AuthnContextComparisonTypeEnumeration;
import org.opensaml.saml.saml2.core.AuthnRequest;
import org.opensaml.saml.saml2.core.Issuer;
import org.opensaml.saml.saml2.core.NameIDPolicy;
import org.opensaml.saml.saml2.core.NameIDType;
import org.opensaml.saml.saml2.core.RequestedAuthnContext;
import org.opensaml.saml.saml2.metadata.Endpoint;
import org.opensaml.saml.saml2.metadata.SingleSignOnService;
import org.opensaml.xmlsec.SignatureSigningParameters;
import org.opensaml.xmlsec.config.impl.JavaCryptoValidationInitializer;
import org.opensaml.xmlsec.context.SecurityParametersContext;
import org.opensaml.xmlsec.signature.support.SignatureConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.joda.time.DateTime;

import net.shibboleth.utilities.java.support.component.ComponentInitializationException;
import net.shibboleth.utilities.java.support.xml.BasicParserPool;
import net.shibboleth.utilities.java.support.xml.ParserPool;
import no.steras.opensamlSamples.opensaml4WebprofileDemo.OpenSAMLUtils;

public class AccessFilter implements Filter {
	private static Logger logger = LoggerFactory.getLogger(AccessFilter.class);

	public void init(FilterConfig filterConfig) throws ServletException {
		try {
			logger.info("Initializing");
			InitializationService.initialize();
		} catch (InitializationException e) {
			throw new RuntimeException("Initialization failed");
		}
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpServletRequest = (HttpServletRequest) request;
		HttpServletResponse httpServletResponse = (HttpServletResponse) response;

		if (httpServletRequest.getSession().getAttribute(SPConstants.AUTHENTICATED_SESSION_ATTRIBUTE) != null) {
			chain.doFilter(request, response);
		} else {
			setGotoURLOnSession(httpServletRequest);
			redirectUserForAuthentication(httpServletResponse);
		}
	}

	private void setGotoURLOnSession(HttpServletRequest request) {
		request.getSession().setAttribute(SPConstants.GOTO_URL_SESSION_ATTRIBUTE, request.getRequestURL().toString());
	}

	private void redirectUserForAuthentication(HttpServletResponse httpServletResponse) {
		AuthnRequest authnRequest = buildAuthnRequest();
		redirectUserWithRequest(httpServletResponse, authnRequest);

	}

	private void redirectUserWithRequest(HttpServletResponse httpServletResponse, AuthnRequest authnRequest) {

		MessageContext<SAMLObject> context = new MessageContext<>();

		context.setMessage(authnRequest);

		SAMLBindingContext bindingContext = context.getSubcontext(SAMLBindingContext.class, true);

		SAMLPeerEntityContext peerEntityContext = context.getSubcontext(SAMLPeerEntityContext.class, true);

		SAMLEndpointContext endpointContext = peerEntityContext.getSubcontext(SAMLEndpointContext.class, true);
		endpointContext.setEndpoint(getIPDEndpoint());

		SignatureSigningParameters signatureSigningParameters = new SignatureSigningParameters();
		signatureSigningParameters.setSigningCredential(SPCredentials.getCredential());
		signatureSigningParameters.setSignatureAlgorithm(SignatureConstants.ALGO_ID_SIGNATURE_RSA_SHA256);

		context.getSubcontext(SecurityParametersContext.class, true)
				.setSignatureSigningParameters(signatureSigningParameters);

		HTTPRedirectDeflateEncoder encoder = new HTTPRedirectDeflateEncoder();

		encoder.setMessageContext(context);
		encoder.setHttpServletResponse(httpServletResponse);

		try {
			encoder.initialize();
		} catch (ComponentInitializationException e) {
			throw new RuntimeException(e);
		}

		logger.info("AuthnRequest: ");
		OpenSAMLUtils.logSAMLObject(authnRequest);

		logger.info("Redirecting to IDP");
		try {
			encoder.encode();
		} catch (MessageEncodingException e) {
			throw new RuntimeException(e);
		}
	}

	private AuthnRequest buildAuthnRequest() {
		AuthnRequest authnRequest = OpenSAMLUtils.buildSAMLObject(AuthnRequest.class);
		authnRequest.setIssueInstant(new DateTime());
		authnRequest.setDestination(getIPDSSODestination());
		authnRequest.setProtocolBinding(SAMLConstants.SAML2_ARTIFACT_BINDING_URI);
		authnRequest.setAssertionConsumerServiceURL(getAssertionConsumerEndpoint());
		authnRequest.setID(OpenSAMLUtils.generateSecureRandomId());
		authnRequest.setIssuer(buildIssuer());
		authnRequest.setNameIDPolicy(buildNameIdPolicy());
		authnRequest.setRequestedAuthnContext(buildRequestedAuthnContext());

		return authnRequest;
	}

	private RequestedAuthnContext buildRequestedAuthnContext() {
		RequestedAuthnContext requestedAuthnContext = OpenSAMLUtils.buildSAMLObject(RequestedAuthnContext.class);
		requestedAuthnContext.setComparison(AuthnContextComparisonTypeEnumeration.MINIMUM);

		AuthnContextClassRef passwordAuthnContextClassRef = OpenSAMLUtils.buildSAMLObject(AuthnContextClassRef.class);
		passwordAuthnContextClassRef.setAuthnContextClassRef(AuthnContext.PASSWORD_AUTHN_CTX);

		requestedAuthnContext.getAuthnContextClassRefs().add(passwordAuthnContextClassRef);

		return requestedAuthnContext;
	}

	private NameIDPolicy buildNameIdPolicy() {
		NameIDPolicy nameIDPolicy = OpenSAMLUtils.buildSAMLObject(NameIDPolicy.class);
		nameIDPolicy.setAllowCreate(true);

		nameIDPolicy.setFormat(NameIDType.TRANSIENT);

		return nameIDPolicy;
	}

	private Issuer buildIssuer() {
		Issuer issuer = OpenSAMLUtils.buildSAMLObject(Issuer.class);
		issuer.setValue(getSPIssuerValue());

		return issuer;
	}

	private String getSPIssuerValue() {
		return SPConstants.SP_ENTITY_ID;
	}

	private String getAssertionConsumerEndpoint() {
		return SPConstants.ASSERTION_CONSUMER_SERVICE;
	}

	private String getIPDSSODestination() {
		return "https://localhost:9443/samlsso";
	}

	private Endpoint getIPDEndpoint() {
		SingleSignOnService endpoint = OpenSAMLUtils.buildSAMLObject(SingleSignOnService.class);
		endpoint.setBinding(SAMLConstants.SAML2_REDIRECT_BINDING_URI);
		endpoint.setLocation(getIPDSSODestination());

		return endpoint;
	}

	public void destroy() {
		System.out.println("destroyed");
	}
}