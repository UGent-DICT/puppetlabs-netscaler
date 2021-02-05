require_relative '../../../puppet/provider/netscaler'
require 'base64'
require 'json'

Puppet::Type.type(:netscaler_authenticationsamlaction).provide(:rest, parent: Puppet::Provider::Netscaler) do
  def netscaler_api_type
    'authenticationsamlaction'
  end

  def self.instances
    instances = []
    actions = Puppet::Provider::Netscaler.call('/config/authenticationsamlaction')
    return [] if actions.nil?

    #TODO: make sensible property names out of these and apply that to the type.
    actions.each do |action|
      instances << new(ensure: :present,
                       name: action['name'],
                       saml_metadata_url: action['metadataurl'],
                       saml_idp_certname: action['samlidpcertname'],
                       saml_signing_certname: action['samlsigningcertname'],
                       saml_redirecturl: action['samlredirecturl'],
                       saml_acsindex: action['samlacsindex'],
                       saml_userfield: action['samluserfield'],
                       saml_reject_unsigned_assertion: action['samlrejectunsignedassertion'],
                       saml_issuername: action['samlissuername'],
                       saml_twofactor: action['samltwofactor'],
                       default_authenticationgroup: action['defaultauthenticationgroup'],
                       attribute1: action['attribute1'],
                       attribute2: action['attribute2'],
                       attribute3: action['attribute3'],
                       attribute4: action['attribute4'],
                       attribute5: action['attribute5'],
                       attribute6: action['attribute6'],
                       attribute7: action['attribute7'],
                       attribute8: action['attribute8'],
                       attribute9: action['attribute9'],
                       attribute10: action['attribute10'],
                       attribute11: action['attribute11'],
                       attribute12: action['attribute12'],
                       attribute13: action['attribute13'],
                       attribute14: action['attribute14'],
                       attribute15: action['attribute15'],
                       attribute16: action['attribute16'],
                       signature_algorithm: action['signaturealg'],
                       digest_method: action['digestmethod'],
                       requested_authentication_context: action['requestedauthncontext'],
                       authenticationclass_ref: action['authnctxclassref'],
                       samlbinding: action['samlbinding'],
                       attribute_consuming_service_index: action['attributeconsumingserviceindex'],
                       send_thumbprint: action['sendthumbprint'],
                       enforce_username: action['enforceusername'],
                       logout_url: action['logouturl'],
                       artifact_resolutionservice_url: action['artifactresolutionserviceurl'],
                       skewtime: action['skewtime'],
                       logout_binding: action['logoutbinding'],
                       force_authentication: action['forceauthn'],
                       groupname_field: action['groupnamefield'],
                       audience: action['audience'])
    end

    instances
  end

  mk_resource_methods

  # Map for conversion in the message.
  def property_to_rest_mapping
    {
      saml_metadata_url: :metadataurl,
      saml_idp_certname: :samlidpcertname,
      saml_signing_certname: :samlsigningcertname,
      saml_redirecturl: :samlredirecturl,
      saml_acsindex: :samlacsindex,
      saml_userfield: :samluserfield,
      saml_reject_unsigned_assertion: :samlrejectunsignedassertion,
      saml_issuername: :samlissuername,
      saml_twofactor: :samltwofactor,
      default_authenticationgroup: :defaultauthenticationgroup,
      signature_algorithm: :signaturealg,
      digest_method: :digestmethod,
      requested_authentication_context: :requestedauthncontext,
      authenticationclass_ref: :authnctxclassref,
      attribute_consuming_service_index: :attributeconsumingserviceindex,
      send_thumbprint: :sendthumbprint,
      enforce_username: :enforceusername,
      logout_url: :logouturl,
      artifact_resolutionservice_url: :artifactresolutionserviceurl,
      logout_binding: :logoutbinding,
      force_authentication: :forceauthn,
      groupname_field: :groupnamefield,
    }
  end

  def immutable_properties
    [
    ]
  end

  def per_provider_munge(message)
    message
  end
end
