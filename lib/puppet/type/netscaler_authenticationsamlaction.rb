require_relative('../../puppet/parameter/netscaler_name')
require_relative('../../puppet/property/netscaler_truthy')

Puppet::Type.newtype(:netscaler_authenticationsamlaction) do
  @doc = 'Configuration for system authenticationsamlaction resource.'

  apply_to_device
  ensurable

  newparam(:name, parent: Puppet::Parameter::NetscalerName, namevar: true)

  newproperty(:saml_metadata_url) do
    desc 'This URL is used for obtaining saml metadata. Note that it fills samlIdPCertName and samlredirectUrl fields so those fields should not be updated when metadataUrl present.'
  end

  newproperty(:saml_idp_certname) do
    desc 'Name of the NetScaler named rule, or a default syntax expression, that the action uses to determine whether to attempt to authenticate the user with the SAML server.'
  end

  newproperty(:saml_signing_certname) do
    desc 'Name of the signing authority as given in the SAML server\'s SSL certificate.'
  end

  newproperty(:saml_redirecturl) do
    desc 'URL to which users are redirected for authentication.'
  end

  newproperty(:saml_acsindex) do
    desc 'Index/ID of the metadata entry corresponding to this configuration.'

    validate do |value|
      unless value.is_a?(Integer) && Integer(value).between?(0, 255)
        raise ArgumentError, 'samlacsindex should be a number between 0 and 255.'
      end
    end

    munge do |value|
      Integer(value)
    end
  end

  newproperty(:saml_userfield) do
    desc 'SAML user ID, as given in the SAML assertion.'
  end

  newproperty(:saml_reject_unsigned_assertion) do
    desc 'Reject unsigned SAML assertions. ON option results in rejection of Assertion that is received without signature. STRICT option ensures that both Response and Assertion are signed. OFF allows unsigned Assertions.'
    validate do |value|
      unless ['ON', 'STRICT', 'OFF'].include?(value)
        raise ArgumentError, 'samlrejectunsignedassertion should be one of "ON", "STRICT" or "OFF".'
      end
    end
  end

  newproperty(:saml_issuername) do
    desc 'The name to be used in requests sent from Netscaler to IdP to uniquely identify Netscaler.'
  end

  newproperty(:saml_twofactor) do
    desc 'Option to enable second factor after SAML.'
  end

  newproperty(:default_authenticationgroup) do
    desc 'This is the default group that is chosen when the authentication succeeds in addition to extracted groups. '
  end

  newproperty(:attribute1) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute1. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute2) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute2. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute3) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute3. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute4) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute4. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute5) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute5. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute6) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute6. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute7) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute7. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute8) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute8. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute9) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute9. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute10) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute10. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute11) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute11. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute12) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute12. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute13) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute13. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute14) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute14. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute15) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute15. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:attribute16) do
    desc 'Name of the attribute in SAML Assertion whose value needs to be extracted and stored as attribute16. Maximum length of the extracted attribute is 239 bytes.'
  end

  newproperty(:signature_algortithm) do
    desc 'Algorithm to be used to compute/verify digest for SAML transactions.'
    validate do |value|
      unless ['SHA1', 'SHA256'].include?(value)
        raise ArgumentError, 'signaturealg should be either "SHA1" or "SHA256".'
      end
    end
  end

  newproperty(:requested_authentication_context) do
    desc 'This element specifies the authentication context requirements of authentication statements returned in the response.'
    validate do |value|
      unless ['exact', 'minimum', 'maximum', 'better'].include?(value)
        raise ArgumentError, 'requestedauthncontext should be one of "exact", "minimum", "maximum", "better"'
      end
    end
  end

  newproperty(:authenticationclass_ref) do
    desc 'This element specifies the authentication class types that are requested from IdP (IdentityProvider)'
    validate do |value|
      unless ['InternetProtocol', 'InternetProtocolPassword', 'Kerberos', 'MobileOneFactorUnregistered', 'MobileTwoFactorUnregistered', 'MobileOneFactorContract', 'MobileTwoFactorContract', 'Password', 'PasswordProtectedTransport', 'PreviousSession', 'X509', 'PGP', 'SPKI', 'XMLDSig', 'Smartcard', 'SmartcardPKI', 'SoftwarePKI', 'Telephony', 'NomadTelephony', 'PersonalTelephony', 'AuthenticatedTelephony', 'SecureRemotePassword', 'TLSClient', 'TimeSyncToken', 'Unspecified', 'Windows'].include?(value)
        raise ArgumentError, 'Invalid value for authnctxclassref, see the netscaler NITRO documentation for more info.'
      end
    end
  end

  newproperty(:samlbinding) do
    desc 'This element specifies the transport mechanism of saml messages.'

    validate do |value|
      unless ['REDIRECT', 'POST', 'ARTIFACT'].include?(value)
        raise ArgumentError, 'samlbinding should be one of "REDIRECT", "POST" or "ARTIFACT".'
      end
    end
  end

  newproperty(:attribute_consuming_service_index) do
    desc 'Index/ID of the attribute specification at Identity Provider (IdP). IdP will locate attributes requested by SP using this index and send those attributes in Assertion.'

    validate do |value|
      unless value.is_a?(Integer) && Integer(value).between?(0, 255)
        raise ArgumentError, 'samlacsindex should be a number between 0 and 255.'
      end
    end
  end

  newproperty(:send_thumbprint, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Option to send thumbprint instead of x509 certificate in SAML request.', 'ON', 'OFF')
  end

  newproperty(:enforce_username, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Option to choose whether the username that is extracted from SAML assertion can be edited in login page while doing second factor.', 'ON', 'OFF')
  end

  newproperty(:logout_url) do
    desc 'SingleLogout URL on IdP to which logoutRequest will be sent on Netscaler session cleanup.'
  end

  newproperty(:artifact_resolutionservice_url) do
    desc 'URL of the Artifact Resolution Service on IdP to which Netscaler will post artifact to get actual SAML token.'
  end

  newproperty(:skewtime) do
    desc 'This option specifies the allowed clock skew in number of minutes that Netscaler ServiceProvider allows on an incoming assertion. For example, if skewTime is 10, then assertion would be valid from (current time - 10) min to (current time + 10) min, ie 20min in all.'
    validate do |value|
      unless value.is_a?(Integer)
        raise ArgumentError, 'Skewtime should be an integer.'
      end
    end
  end

  newproperty(:logout_binding) do
    desc 'This element specifies the transport mechanism of saml logout messages. '
    validate do |value|
      unless ['REDIRECT', 'POST'].include?(value)
        raise ArgumentError, 'logoutbinding should be either "REDIRECT" or "POST".'
      end
    end
  end

  newproperty(:force_authentication, parent: Puppet::Property::NetscalerTruthy) do
    truthy_property('Option that forces authentication at the Identity Provider (IdP) that receives Netscaler\'s request.', 'ON', 'OFF')
  end

  newproperty(:groupname_field) do
    desc 'Name of the tag in assertion that contains user groups.'
  end

  newproperty(:audience) do
    desc 'Audience for which assertion sent by IdP is applicable. This is typically entity name or url that represents ServiceProvider.'
  end
end
