package no.steras.opensamlSamples.opensaml4WebprofileDemo.sp;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.Optional;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.opensaml.core.config.InitializationException;
import org.opensaml.core.config.InitializationService;
import org.opensaml.core.xml.config.XMLObjectProviderRegistrySupport;
import org.opensaml.core.xml.io.UnmarshallingException;
import org.opensaml.core.xml.io.Unmarshaller;
import org.opensaml.core.xml.XMLObject;
import org.opensaml.saml.saml2.core.Response;
import org.opensaml.xml.security.keyinfo.KeyInfoHelper;
import org.opensaml.xml.security.x509.BasicX509Credential;
import org.opensaml.xml.signature.SignatureConstants;
import org.opensaml.xmlsec.signature.X509Certificate;
import org.opensaml.xmlsec.signature.support.SignatureValidator;
import org.opensaml.saml.saml2.core.Assertion;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import net.shibboleth.utilities.java.support.component.ComponentInitializationException;
import net.shibboleth.utilities.java.support.xml.BasicParserPool;
import net.shibboleth.utilities.java.support.xml.XMLParserException;

public class ConsumerServlet extends HttpServlet {

	@Override
	protected void doPost(final HttpServletRequest req, final HttpServletResponse resp)
			throws ServletException, IOException {

		String responseMessage = req.getParameter("SAMLResponse");
		byte[] base64DecodedResponse = Base64.getDecoder().decode(responseMessage);

		ByteArrayInputStream is = new ByteArrayInputStream(base64DecodedResponse);

		try {
			InitializationService.initialize();
			Document messageDoc;
			BasicParserPool basicParserPool = new BasicParserPool();
			basicParserPool.initialize();
			messageDoc = basicParserPool.parse(is);
			Element messageElem = messageDoc.getDocumentElement();
			Unmarshaller unmarshaller = XMLObjectProviderRegistrySupport.getUnmarshallerFactory()
					.getUnmarshaller(messageElem);

			assert unmarshaller != null;

			XMLObject responseXmlObj = unmarshaller.unmarshall(messageElem);
			Response response = (Response) responseXmlObj;

			Assertion assertion = response.getAssertions().get(0);
			String subject = assertion.getSubject().getNameID().getValue();
			String issuer = assertion.getIssuer().getValue();
			String audience = assertion.getConditions().getAudienceRestrictions().get(0).getAudiences().get(0)
					.getAudienceURI();
			String statusCode = response.getStatus().getStatusCode().getValue();

			for (Assertion asser : response.getAssertions()) {
				try {
					if (asser.getSignature() != null) {
						Optional<X509Certificate> x509Certificate = asser.getSignature().getKeyInfo().getX509Datas()
								.stream()
								.findFirst()
								.map(x509Data -> x509Data.getX509Certificates()
										.stream()
										.findFirst()
										.orElse(null));
						if (x509Certificate.isPresent()) {
							SignatureValidator.validate(asser.getSignature(), SPCredentials.getCredential());
							System.out.println("--------Assertion Signature Verified--------");
						}
					} else {
						System.out.println("-----------Assertion is null-----------");
					}
				} catch (Exception e) {
					System.out.println(e);
					throw new RuntimeException("Assertion Signature Invalid");
				}
			}

			System.out.println("\nSubject		: " + subject);
			System.out.println("Issuer		: " + issuer);
			System.out.println("Audience	: " + audience);
			System.out.println("StatusCode	: " + statusCode + "\n");

		} catch (InitializationException e) {
			e.printStackTrace();
		} catch (XMLParserException e) {
			e.printStackTrace();
		} catch (UnmarshallingException e) {
			e.printStackTrace();
		} catch (ComponentInitializationException e) {
			e.printStackTrace();
		}

	}

	private void verifyAssertionSignature(Assertion assertion) {

		if (!assertion.isSigned()) {
			throw new RuntimeException("The SAML Assertion was not signed");
		}

		try {

			// logger.info("SAML Assertion signature verified");
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
