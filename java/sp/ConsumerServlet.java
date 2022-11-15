package no.steras.opensamlSamples.opensaml4WebprofileDemo.sp;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Optional;
import java.util.function.Function;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport;
import org.opensaml.core.xml.io.UnmarshallingException;
import org.opensaml.core.xml.io.Unmarshaller;
import org.opensaml.core.xml.XMLObject;
import org.opensaml.saml.saml2.core.Response;
import org.opensaml.saml.saml2.encryption.Decrypter;
import org.opensaml.xmlsec.encryption.support.InlineEncryptedKeyResolver;
import org.opensaml.xmlsec.keyinfo.impl.StaticKeyInfoCredentialResolver;
import org.opensaml.xmlsec.signature.X509Certificate;
import org.opensaml.xmlsec.signature.X509Data;
import org.opensaml.xmlsec.signature.support.SignatureValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.opensaml.saml.saml2.core.Assertion;
import org.opensaml.saml.saml2.core.EncryptedAssertion;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import net.shibboleth.utilities.java.support.component.ComponentInitializationException;
import net.shibboleth.utilities.java.support.xml.BasicParserPool;
import net.shibboleth.utilities.java.support.xml.XMLParserException;
import no.steras.opensamlSamples.opensaml4WebprofileDemo.OpenSAMLUtils;

public class ConsumerServlet extends HttpServlet {

	private static Logger logger = LoggerFactory.getLogger(ConsumerServlet.class);

	@Override
	protected void doPost(final HttpServletRequest req, final HttpServletResponse resp)
			throws ServletException, IOException {

		String responseMessage = req.getParameter("SAMLResponse");
		byte[] base64DecodedResponse = Base64.getDecoder().decode(responseMessage);

		ByteArrayInputStream is = new ByteArrayInputStream(base64DecodedResponse);

		try {
			Document messageDoc;
			BasicParserPool basicParserPool = new BasicParserPool();
			basicParserPool.initialize();
			messageDoc = basicParserPool.parse(is);
			Element messageElem = messageDoc.getDocumentElement();
			Unmarshaller unmarshaller = XMLObjectProviderRegistrySupport.getUnmarshallerFactory()
					.getUnmarshaller(messageElem);

			XMLObject responseXmlObj = unmarshaller.unmarshall(messageElem);
			Response response = (Response) responseXmlObj;

			OpenSAMLUtils.logSAMLObject(response);

			StaticKeyInfoCredentialResolver keyInfoCredentialResolver = new StaticKeyInfoCredentialResolver(
					SPCredentials.getCredential());

			Assertion assertion = null;
			EncryptedAssertion encryptedAssertion = response.getEncryptedAssertions().get(0);

			Decrypter decrypter = new Decrypter(null, keyInfoCredentialResolver, new InlineEncryptedKeyResolver());

			try {
				assertion = decrypter.decrypt(encryptedAssertion);
				logger.info("Decrypted Assertion: ");
				OpenSAMLUtils.logSAMLObject(assertion);
			} catch (Exception e) {
				System.out.println(e);
			}

			String subject = assertion.getSubject().getNameID().getValue();
			String issuer = assertion.getIssuer().getValue();
			String audience = assertion.getConditions().getAudienceRestrictions().get(0).getAudiences().get(0)
					.getAudienceURI();
			String statusCode = response.getStatus().getStatusCode().getValue();

			verifySignature(response);

			System.out.println("\nSubject		: " + subject);
			System.out.println("Issuer		: " + issuer);
			System.out.println("Audience	: " + audience);
			System.out.println("StatusCode	: " + statusCode + "\n");

			req.getSession().setAttribute(SPConstants.AUTHENTICATED_SESSION_ATTRIBUTE, "true");

			assertion.getAttributeStatements();

			redirectToGotoURL(req, resp);

		} catch (XMLParserException e) {
			e.printStackTrace();
		} catch (UnmarshallingException e) {
			e.printStackTrace();
		} catch (ComponentInitializationException e) {
			e.printStackTrace();
		}
	}

	private void verifySignature(Response response) {
		for (Assertion asser : response.getAssertions()) {
			try {
				if (asser.getSignature() != null) {
					Optional<X509Certificate> x509Certificate = asser.getSignature().getKeyInfo().getX509Datas()
							.stream()
							.findFirst()
							.map(new Function<X509Data, X509Certificate>() {
								public X509Certificate apply(X509Data x509Data) {
									return x509Data.getX509Certificates()
											.stream()
											.findFirst()
											.orElse(null);
								}
							});
					if (x509Certificate.isPresent()) {
						SignatureValidator.validate(asser.getSignature(), SPCredentials.getCredential());
						System.out.println("\n--------Assertion Signature Verified--------");
					}
				} else {
					System.out.println("-----------Assertion is null-----------");
				}
			} catch (Exception e) {
				System.out.println(e);
				throw new RuntimeException("Assertion Signature Invalid");
			}
		}
	}

	private void redirectToGotoURL(HttpServletRequest req, HttpServletResponse resp) {
		String gotoURL = (String) req.getSession().getAttribute(SPConstants.GOTO_URL_SESSION_ATTRIBUTE);
		logger.info("Redirecting to requested URL: " + gotoURL);
		try {
			resp.sendRedirect(gotoURL);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	private static void printNodeList(NodeList nodeList) {
		for (int count = 0; count < nodeList.getLength(); count++) {
			Node elemNode = nodeList.item(count);
			if (elemNode.getNodeType() == Node.ELEMENT_NODE) {
				if (elemNode.hasAttributes()) {
					NamedNodeMap nodeMap = elemNode.getAttributes();
					System.out.println("Attribute	= " + nodeMap.item(0).getNodeValue());
					System.out.println("Value	    	= " + elemNode.getTextContent() + "\n");
				}
			}
		}
	}

}
