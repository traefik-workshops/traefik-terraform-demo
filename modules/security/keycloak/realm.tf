resource "kubectl_manifest" "keycloak_realm" {
  depends_on = [kubectl_manifest.keycloak_crd]

  yaml_body = <<YAML
apiVersion: k8s.keycloak.org/v2alpha1
kind: KeycloakRealmImport
metadata:
  name: traefik
  namespace: traefik-security
spec:
  keycloakCRName: keycloak
  realm:
    users: ${jsonencode([
      for username in var.users : {
        enabled         = true
        emailVerified   = true
        username        = username
        email          = "${username}@example.com"
        firstName      = title(username)
        lastName       = "Example"
        credentials    = [
          {
            value     = "topsecretpassword"
            type      = "password"
            temporary = false
          }
        ]
        groups         = ["${username}s"]
      }
    ])}
    id: 9e470c18-f69f-4ebd-9006-5d4ed05c1cf2
    realm: traefik
    notBefore: 0
    defaultSignatureAlgorithm: RS256
    revokeRefreshToken: false
    refreshTokenMaxReuse: 0
    accessTokenLifespan: 86400
    accessTokenLifespanForImplicitFlow: 900
    ssoSessionIdleTimeout: 1800
    ssoSessionMaxLifespan: 36000
    ssoSessionIdleTimeoutRememberMe: 0
    ssoSessionMaxLifespanRememberMe: 0
    offlineSessionIdleTimeout: 2592000
    offlineSessionMaxLifespanEnabled: false
    offlineSessionMaxLifespan: 5184000
    clientSessionIdleTimeout: 0
    clientSessionMaxLifespan: 0
    clientOfflineSessionIdleTimeout: 0
    clientOfflineSessionMaxLifespan: 0
    accessCodeLifespan: 60
    accessCodeLifespanUserAction: 300
    accessCodeLifespanLogin: 1800
    actionTokenGeneratedByAdminLifespan: 43200
    actionTokenGeneratedByUserLifespan: 300
    oauth2DeviceCodeLifespan: 600
    oauth2DevicePollingInterval: 5
    enabled: true
    sslRequired: external
    registrationAllowed: false
    registrationEmailAsUsername: false
    rememberMe: false
    verifyEmail: false
    loginWithEmailAllowed: true
    duplicateEmailsAllowed: false
    resetPasswordAllowed: false
    editUsernameAllowed: false
    bruteForceProtected: false
    permanentLockout: false
    maxFailureWaitSeconds: 900
    minimumQuickLoginWaitSeconds: 60
    waitIncrementSeconds: 60
    quickLoginCheckMilliSeconds: 1000
    maxDeltaTimeSeconds: 43200
    failureFactor: 30
    roles:
      realm:
        - id: c0b4d45e-fbb6-4abe-ba8e-c312ccea0565
          name: uma_authorization
          description: '$${role_uma_authorization}'
          composite: false
          clientRole: false
          containerId: 9e470c18-f69f-4ebd-9006-5d4ed05c1cf2
          attributes: { }
        - id: f122515c-6e08-4412-aad1-961b6bc03dd9
          name: offline_access
          description: '$${role_offline-access}'
          composite: false
          clientRole: false
          containerId: 9e470c18-f69f-4ebd-9006-5d4ed05c1cf2
          attributes: { }
        - id: 029a8b80-9512-4ca9-ab98-d2ac64747514
          name: default-roles-traefik
          description: '$${role_default-roles}'
          composite: true
          composites:
            realm:
              - offline_access
              - uma_authorization
            client:
              account:
                - manage-account
                - view-profile
          clientRole: false
          containerId: 9e470c18-f69f-4ebd-9006-5d4ed05c1cf2
          attributes: { }
      client:
        realm-management:
          - id: 4f05e33c-6525-46e6-aec7-d43c6fd5a819
            name: manage-realm
            description: '$${role_manage-realm}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 128105cc-0332-4500-b564-5f9f036342e5
            name: realm-admin
            description: '$${role_realm-admin}'
            composite: true
            composites:
              client:
                realm-management:
                  - manage-realm
                  - query-realms
                  - impersonation
                  - manage-clients
                  - view-users
                  - manage-identity-providers
                  - query-clients
                  - view-clients
                  - query-groups
                  - manage-users
                  - view-realm
                  - view-identity-providers
                  - view-authorization
                  - create-client
                  - manage-authorization
                  - view-events
                  - manage-events
                  - query-users
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 3466645a-e83b-454a-8cd8-8917b9831c7e
            name: query-realms
            description: '$${role_query-realms}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: a9eb0cb8-b509-4cc0-bbec-aac92583a089
            name: impersonation
            description: '$${role_impersonation}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 4ace5c87-6a6a-49f7-aed1-10a53ab390a1
            name: manage-clients
            description: '$${role_manage-clients}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: dead5dc9-e698-436e-8532-c6ca3600321b
            name: view-users
            description: '$${role_view-users}'
            composite: true
            composites:
              client:
                realm-management:
                  - query-users
                  - query-groups
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 6bacca26-eaed-4778-934d-14c6d6838e59
            name: manage-identity-providers
            description: '$${role_manage-identity-providers}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 4a39f243-bbc4-4e63-ab5f-9d3d30ec65e5
            name: query-clients
            description: '$${role_query-clients}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 32aab625-5271-42a1-8347-b2ff7faf4a16
            name: view-clients
            description: '$${role_view-clients}'
            composite: true
            composites:
              client:
                realm-management:
                  - query-clients
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 5a466e39-d1b5-485f-9192-692d7ba4ccad
            name: manage-users
            description: '$${role_manage-users}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: dd5bf33b-8441-4b66-b6d9-fe85662cae86
            name: query-groups
            description: '$${role_query-groups}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 91d2e38b-153e-4884-91b3-40461e1538f1
            name: view-identity-providers
            description: '$${role_view-identity-providers}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: a49b0276-d724-4366-aaa7-b5f79f7f67a8
            name: view-realm
            description: '$${role_view-realm}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 55ebdd59-8ec6-4a1a-96b0-f5a09d05eefe
            name: view-authorization
            description: '$${role_view-authorization}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 577327dd-fee7-4d9b-8a36-6a900573456e
            name: create-client
            description: '$${role_create-client}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 72d46a47-c5ee-4a96-a952-ca16eed38637
            name: manage-authorization
            description: '$${role_manage-authorization}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 576e83ca-05cb-4fad-a0fd-51d75a6f4080
            name: view-events
            description: '$${role_view-events}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: 5170ae52-9c95-4e02-8679-e734208355fa
            name: manage-events
            description: '$${role_manage-events}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
          - id: be6586fa-2ac7-450c-bbd0-44c441db7b02
            name: query-users
            description: '$${role_query-users}'
            composite: false
            clientRole: true
            containerId: 3d5dc82f-e557-442f-86a7-a63c51360d0a
            attributes: { }
        security-admin-console: [ ]
        admin-cli: [ ]
        account-console: [ ]
        broker:
          - id: 89e601a8-ef0d-46ac-ab63-609eacabc06c
            name: read-token
            description: '$${role_read-token}'
            composite: false
            clientRole: true
            containerId: c06aa8d9-fa64-46b0-989c-3c2fb66c9f4b
            attributes: { }
        account:
          - id: ec309ff6-12c7-4674-9830-316a71d8afd3
            name: manage-account
            description: '$${role_manage-account}'
            composite: true
            composites:
              client:
                account:
                  - manage-account-links
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: d4beb6ae-394b-401e-8177-bd6e56575dd5
            name: view-consent
            description: '$${role_view-consent}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: 2bc0639a-76df-4023-9849-b092d77cb39e
            name: manage-consent
            description: '$${role_manage-consent}'
            composite: true
            composites:
              client:
                account:
                  - view-consent
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: 645efac6-dff1-4daf-8393-fe5ce5d48c18
            name: delete-account
            description: '$${role_delete-account}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: 6b5421d1-88bb-4dae-85e6-1eaab1c18ba7
            name: view-applications
            description: '$${role_view-applications}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: 2b0371b2-7505-43a1-b269-466731328b6e
            name: view-profile
            description: '$${role_view-profile}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: 3ef16dab-c3b7-4dc5-8ba8-8bc813e6e4ce
            name: manage-account-links
            description: '$${role_manage-account-links}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
          - id: da6e480f-e2d5-4a90-8ca0-551246fc0356
            name: view-groups
            description: '$${role_view-groups}'
            composite: false
            clientRole: true
            containerId: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
            attributes: { }
        traefik: [ ]
    groups: ${jsonencode([
      for username in var.users : {
        id: uuid()
        name: "${username}s"
        path: "/${username}s"
        attributes: {}
        realmRoles: []
        clientRoles: {}
        subGroups: []
      }
    ])}
    defaultRole:
      id: 029a8b80-9512-4ca9-ab98-d2ac64747514
      name: default-roles-traefik
      description: '$${role_default-roles}'
      composite: true
      clientRole: false
      containerId: 9e470c18-f69f-4ebd-9006-5d4ed05c1cf2
    requiredCredentials:
      - password
    otpPolicyType: totp
    otpPolicyAlgorithm: HmacSHA1
    otpPolicyInitialCounter: 0
    otpPolicyDigits: 6
    otpPolicyLookAheadWindow: 1
    otpPolicyPeriod: 30
    otpPolicyCodeReusable: false
    otpSupportedApplications:
      - totpAppMicrosoftAuthenticatorName
      - totpAppGoogleName
      - totpAppFreeOTPName
    webAuthnPolicyRpEntityName: keycloak
    webAuthnPolicySignatureAlgorithms:
      - ES256
    webAuthnPolicyRpId: ''
    webAuthnPolicyAttestationConveyancePreference: not specified
    webAuthnPolicyAuthenticatorAttachment: not specified
    webAuthnPolicyRequireResidentKey: not specified
    webAuthnPolicyUserVerificationRequirement: not specified
    webAuthnPolicyCreateTimeout: 0
    webAuthnPolicyAvoidSameAuthenticatorRegister: false
    webAuthnPolicyAcceptableAaguids: [ ]
    webAuthnPolicyPasswordlessRpEntityName: keycloak
    webAuthnPolicyPasswordlessSignatureAlgorithms:
      - ES256
    webAuthnPolicyPasswordlessRpId: ''
    webAuthnPolicyPasswordlessAttestationConveyancePreference: not specified
    webAuthnPolicyPasswordlessAuthenticatorAttachment: not specified
    webAuthnPolicyPasswordlessRequireResidentKey: not specified
    webAuthnPolicyPasswordlessUserVerificationRequirement: not specified
    webAuthnPolicyPasswordlessCreateTimeout: 0
    webAuthnPolicyPasswordlessAvoidSameAuthenticatorRegister: false
    webAuthnPolicyPasswordlessAcceptableAaguids: [ ]
    scopeMappings:
      - clientScope: offline_access
        roles:
          - offline_access
    clientScopeMappings:
      account:
        - client: account-console
          roles:
            - manage-account
            - view-groups
    clients:
      - id: 794bc55c-83c2-4e24-95e6-1a30eabc3df7
        clientId: account
        name: '$${client_account}'
        rootUrl: '$${authBaseUrl}'
        baseUrl: /realms/traefik/account/
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris:
          - /realms/traefik/account/*
        webOrigins: [ ]
        notBefore: 0
        bearerOnly: false
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: false
        serviceAccountsEnabled: false
        publicClient: true
        frontchannelLogout: false
        protocol: openid-connect
        attributes:
          post.logout.redirect.uris: +
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: df6592e5-c43c-4d6c-9f9e-5b7d29ee7372
        clientId: account-console
        name: '$${client_account-console}'
        rootUrl: '$${authBaseUrl}'
        baseUrl: /realms/traefik/account/
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris:
          - /realms/traefik/account/*
        webOrigins: [ ]
        notBefore: 0
        bearerOnly: false
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: false
        serviceAccountsEnabled: false
        publicClient: true
        frontchannelLogout: false
        protocol: openid-connect
        attributes:
          post.logout.redirect.uris: +
          pkce.code.challenge.method: S256
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        protocolMappers:
          - id: 654b5c2f-78d8-442d-bfd4-d1ac57a56586
            name: audience resolve
            protocol: openid-connect
            protocolMapper: oidc-audience-resolve-mapper
            consentRequired: false
            config: { }
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: 82100ba8-3574-4ec5-b5ba-d63ff9c10e5d
        clientId: admin-cli
        name: '$${client_admin-cli}'
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris: [ ]
        webOrigins: [ ]
        notBefore: 0
        bearerOnly: false
        consentRequired: false
        standardFlowEnabled: false
        implicitFlowEnabled: false
        directAccessGrantsEnabled: true
        serviceAccountsEnabled: false
        publicClient: true
        frontchannelLogout: false
        protocol: openid-connect
        attributes: { }
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: c06aa8d9-fa64-46b0-989c-3c2fb66c9f4b
        clientId: broker
        name: '$${client_broker}'
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris: [ ]
        webOrigins: [ ]
        notBefore: 0
        bearerOnly: true
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: false
        serviceAccountsEnabled: false
        publicClient: false
        frontchannelLogout: false
        protocol: openid-connect
        attributes: { }
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: 979ce9c1-b5b3-4edc-b5e8-0330581ce233
        clientId: traefik
        name: traefik
        description: ''
        rootUrl: ''
        adminUrl: ''
        baseUrl: ''
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        secret: 'NoTgoLZpbrr5QvbNDIRIvmZOhe9wI0r0'
        redirectUris:
          - /*
        webOrigins:
          - /*
        notBefore: 0
        bearerOnly: false
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: true
        serviceAccountsEnabled: false
        publicClient: false
        frontchannelLogout: true
        protocol: openid-connect
        attributes:
          oidc.ciba.grant.enabled: 'false'
          oauth2.device.authorization.grant.enabled: 'false'
          client.secret.creation.time: '1699497518'
          backchannel.logout.session.required: 'true'
          backchannel.logout.revoke.offline.tokens: 'false'
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: true
        nodeReRegistrationTimeout: -1
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
          - group
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: 3d5dc82f-e557-442f-86a7-a63c51360d0a
        clientId: realm-management
        name: '$${client_realm-management}'
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris: [ ]
        webOrigins: [ ]
        notBefore: 0
        bearerOnly: true
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: false
        serviceAccountsEnabled: false
        publicClient: false
        frontchannelLogout: false
        protocol: openid-connect
        attributes: { }
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
      - id: df0bc596-6de1-4898-aada-63593259cc8a
        clientId: security-admin-console
        name: '$${client_security-admin-console}'
        rootUrl: '$${authAdminUrl}'
        baseUrl: /admin/traefik/console/
        surrogateAuthRequired: false
        enabled: true
        alwaysDisplayInConsole: false
        clientAuthenticatorType: client-secret
        redirectUris:
          - /admin/traefik/console/*
        webOrigins:
          - +
        notBefore: 0
        bearerOnly: false
        consentRequired: false
        standardFlowEnabled: true
        implicitFlowEnabled: false
        directAccessGrantsEnabled: false
        serviceAccountsEnabled: false
        publicClient: true
        frontchannelLogout: false
        protocol: openid-connect
        attributes:
          post.logout.redirect.uris: +
          pkce.code.challenge.method: S256
        authenticationFlowBindingOverrides: { }
        fullScopeAllowed: false
        nodeReRegistrationTimeout: 0
        protocolMappers:
          - id: d772d1ba-ad04-4964-a2c1-8fe0e7f9ee7a
            name: locale
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: locale
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: locale
              jsonType.label: String
        defaultClientScopes:
          - web-origins
          - acr
          - profile
          - roles
          - email
        optionalClientScopes:
          - address
          - phone
          - offline_access
          - microprofile-jwt
    clientScopes:
      - id: 6703b8f6-b235-4305-b3f5-7043e8077394
        name: acr
        description: >-
          OpenID Connect scope for add acr (authentication context class reference)
          to the token
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'false'
          display.on.consent.screen: 'false'
        protocolMappers:
          - id: ff9d7312-9938-438c-ade3-dfb859bcc353
            name: acr loa level
            protocol: openid-connect
            protocolMapper: oidc-acr-mapper
            consentRequired: false
            config:
              id.token.claim: 'true'
              access.token.claim: 'true'
      - id: 90bb29d9-daad-47ab-a600-267c69080359
        name: phone
        description: 'OpenID Connect built-in scope: phone'
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'true'
          consent.screen.text: '$${phoneScopeConsentText}'
        protocolMappers:
          - id: a25cb269-9653-4d2a-9c5c-f694f969cc66
            name: phone number
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: phoneNumber
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: phone_number
              jsonType.label: String
          - id: 2b998902-2d57-41b4-98fc-2f51e7f5ca4c
            name: phone number verified
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: phoneNumberVerified
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: phone_number_verified
              jsonType.label: boolean
      - id: ddf70450-7e18-4432-8e12-b2eab9deddff
        name: profile
        description: 'OpenID Connect built-in scope: profile'
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'true'
          consent.screen.text: '$${profileScopeConsentText}'
        protocolMappers:
          - id: 199f9a45-1ca0-4958-b677-513bc4eeb832
            name: updated at
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: updatedAt
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: updated_at
              jsonType.label: long
          - id: 34dccbdb-4b3b-4767-8404-79aad98a2e94
            name: middle name
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: middleName
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: middle_name
              jsonType.label: String
          - id: 29d17a40-a3f6-48de-ab10-ddc4e87947c2
            name: full name
            protocol: openid-connect
            protocolMapper: oidc-full-name-mapper
            consentRequired: false
            config:
              id.token.claim: 'true'
              access.token.claim: 'true'
              userinfo.token.claim: 'true'
          - id: efd43ffc-3500-4269-9603-816cb5c5edf1
            name: given name
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: firstName
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: given_name
              jsonType.label: String
          - id: d1985765-fa0a-4c65-a241-589de22655e4
            name: picture
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: picture
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: picture
              jsonType.label: String
          - id: 09493c0e-5608-497b-9509-189259b93268
            name: family name
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: lastName
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: family_name
              jsonType.label: String
          - id: 24155a1f-cf4b-439d-8075-cdbfbd790fef
            name: username
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: username
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: preferred_username
              jsonType.label: String
          - id: cca2aa8c-6166-489c-b1eb-d46f12fbac21
            name: locale
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: locale
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: locale
              jsonType.label: String
          - id: cba34eb6-2232-4f87-a1db-37bd0345abb6
            name: profile
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: profile
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: profile
              jsonType.label: String
          - id: 82c7e219-b084-4c6f-9cbd-cb99724cdaa5
            name: nickname
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: nickname
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: nickname
              jsonType.label: String
          - id: 4427239d-9266-4c51-b515-e90b6ebde470
            name: gender
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: gender
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: gender
              jsonType.label: String
          - id: 2a2a7fdb-2490-411d-9681-a8e72932b853
            name: zoneinfo
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: zoneinfo
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: zoneinfo
              jsonType.label: String
          - id: e096c38d-d1bf-4051-81c3-db74228761bd
            name: website
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: website
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: website
              jsonType.label: String
          - id: 9f1503fa-cbaa-4804-ab7f-2c5637fa29aa
            name: birthdate
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: birthdate
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: birthdate
              jsonType.label: String
      - id: 5677ae82-f5af-46e4-a9a8-e062dc4ac4f1
        name: roles
        description: OpenID Connect scope for add user roles to the access token
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'false'
          display.on.consent.screen: 'true'
          consent.screen.text: '$${rolesScopeConsentText}'
        protocolMappers:
          - id: 82bbcce3-60d5-4b4b-a9f2-3e1d205ed58c
            name: realm roles
            protocol: openid-connect
            protocolMapper: oidc-usermodel-realm-role-mapper
            consentRequired: false
            config:
              user.attribute: foo
              access.token.claim: 'true'
              claim.name: realm_access.roles
              jsonType.label: String
              multivalued: 'true'
          - id: 8cc13abd-67b2-4769-989e-da2354b055e2
            name: client roles
            protocol: openid-connect
            protocolMapper: oidc-usermodel-client-role-mapper
            consentRequired: false
            config:
              user.attribute: foo
              access.token.claim: 'true'
              claim.name: 'resource_access.$${client_id}.roles'
              jsonType.label: String
              multivalued: 'true'
          - id: 7c99283e-8147-4c4b-a210-00149421c343
            name: audience resolve
            protocol: openid-connect
            protocolMapper: oidc-audience-resolve-mapper
            consentRequired: false
            config: { }
      - id: 6228a86a-e277-4e24-8262-83186448ce78
        name: role_list
        description: SAML role list
        protocol: saml
        attributes:
          consent.screen.text: '$${samlRoleListScopeConsentText}'
          display.on.consent.screen: 'true'
        protocolMappers:
          - id: c9a1cb77-6dc6-458e-a8e6-e13dc9227aea
            name: role list
            protocol: saml
            protocolMapper: saml-role-list-mapper
            consentRequired: false
            config:
              single: 'false'
              attribute.nameformat: Basic
              attribute.name: Role
      - id: 302bbbca-0b63-4bb4-9c28-403ee22fc20b
        name: email
        description: 'OpenID Connect built-in scope: email'
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'true'
          consent.screen.text: '$${emailScopeConsentText}'
        protocolMappers:
          - id: d764cf16-9221-470f-90cc-4acb6a2f9eec
            name: email
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: email
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: email
              jsonType.label: String
          - id: db117260-ea76-41d4-957c-2f63b64916d6
            name: email verified
            protocol: openid-connect
            protocolMapper: oidc-usermodel-property-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: emailVerified
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: email_verified
              jsonType.label: boolean
      - id: 15e1c4a1-ea99-4f9e-aa1d-c3f49ae38ca0
        name: address
        description: 'OpenID Connect built-in scope: address'
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'true'
          consent.screen.text: '$${addressScopeConsentText}'
        protocolMappers:
          - id: 377f5a88-1605-4299-a510-d01a8615c208
            name: address
            protocol: openid-connect
            protocolMapper: oidc-address-mapper
            consentRequired: false
            config:
              user.attribute.formatted: formatted
              user.attribute.country: country
              user.attribute.postal_code: postal_code
              userinfo.token.claim: 'true'
              user.attribute.street: street
              id.token.claim: 'true'
              user.attribute.region: region
              access.token.claim: 'true'
              user.attribute.locality: locality
      - id: 7871b811-1020-4378-89e7-dd2c49a69104
        name: web-origins
        description: OpenID Connect scope for add allowed web origins to the access token
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'false'
          display.on.consent.screen: 'false'
          consent.screen.text: ''
        protocolMappers:
          - id: b24a68f5-5403-4652-8fce-c887174a6447
            name: allowed web origins
            protocol: openid-connect
            protocolMapper: oidc-allowed-origins-mapper
            consentRequired: false
            config: { }
      - id: 26365174-f6d7-4db0-b686-7c5a63c0e746
        name: microprofile-jwt
        description: Microprofile - JWT built-in scope
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'false'
        protocolMappers:
          - id: 2e0fcbac-ce68-4999-a473-0296ba4c0a48
            name: groups
            protocol: openid-connect
            protocolMapper: oidc-usermodel-realm-role-mapper
            consentRequired: false
            config:
              multivalued: 'true'
              user.attribute: foo
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: groups
              jsonType.label: String
          - id: 71f88c22-06c8-44ee-bbad-09013c3d88b2
            name: upn
            protocol: openid-connect
            protocolMapper: oidc-usermodel-attribute-mapper
            consentRequired: false
            config:
              userinfo.token.claim: 'true'
              user.attribute: username
              id.token.claim: 'true'
              access.token.claim: 'true'
              claim.name: upn
              jsonType.label: String
      - id: a11e2f48-b0dc-48a5-90c6-d6fa159028b8
        name: offline_access
        description: 'OpenID Connect built-in scope: offline_access'
        protocol: openid-connect
        attributes:
          consent.screen.text: '$${offlineAccessScopeConsentText}'
          display.on.consent.screen: 'true'
      - id: e0078bb4-326d-4793-8445-5081c3185bbf
        name: group
        description: Map user group to JWT
        protocol: openid-connect
        attributes:
          include.in.token.scope: 'true'
          display.on.consent.screen: 'false'
          gui.order: ''
          consent.screen.text: ''
        protocolMappers:
          - id: c8f99a03-3576-4ec4-80ad-38bb49ee334f
            name: group
            protocol: openid-connect
            protocolMapper: oidc-group-membership-mapper
            consentRequired: false
            config:
              full.path: 'false'
              userinfo.token.claim: 'false'
              multivalued: 'true'
              id.token.claim: 'false'
              access.token.claim: 'true'
              claim.name: group
    defaultDefaultClientScopes:
      - role_list
      - profile
      - email
      - roles
      - web-origins
      - acr
    defaultOptionalClientScopes:
      - offline_access
      - address
      - phone
      - microprofile-jwt
    browserSecurityHeaders:
      contentSecurityPolicyReportOnly: ''
      xContentTypeOptions: nosniff
      referrerPolicy: no-referrer
      xRobotsTag: none
      xFrameOptions: SAMEORIGIN
      contentSecurityPolicy: frame-src 'self'; frame-ancestors 'self'; object-src 'none';
      xXSSProtection: 1; mode=block
      strictTransportSecurity: max-age=31536000; includeSubDomains
    smtpServer: { }
    eventsEnabled: false
    eventsListeners:
      - jboss-logging
    enabledEventTypes: [ ]
    adminEventsEnabled: false
    adminEventsDetailsEnabled: false
    identityProviders: [ ]
    identityProviderMappers: [ ]
    components:
      org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy:
        - id: 6e13f0d1-b9c9-4e1e-968d-4d2f9d4d7764
          name: Allowed Client Scopes
          providerId: allowed-client-templates
          subType: anonymous
          subComponents: { }
          config:
            allow-default-scopes:
              - 'true'
        - id: a93d201c-5367-4dbb-b2e0-4feaab79a59d
          name: Allowed Protocol Mapper Types
          providerId: allowed-protocol-mappers
          subType: anonymous
          subComponents: { }
          config:
            allowed-protocol-mapper-types:
              - oidc-usermodel-attribute-mapper
              - saml-user-attribute-mapper
              - oidc-full-name-mapper
              - oidc-address-mapper
              - saml-user-property-mapper
              - oidc-sha256-pairwise-sub-mapper
              - saml-role-list-mapper
              - oidc-usermodel-property-mapper
        - id: 0b72183d-5f7a-4759-8102-ae4086cc001c
          name: Consent Required
          providerId: consent-required
          subType: anonymous
          subComponents: { }
          config: { }
        - id: e69b85e9-ee33-401a-8342-bf3d8c21f010
          name: Allowed Client Scopes
          providerId: allowed-client-templates
          subType: authenticated
          subComponents: { }
          config:
            allow-default-scopes:
              - 'true'
        - id: 6a3c3820-bcc9-4eb7-8ca6-11b07932f878
          name: Full Scope Disabled
          providerId: scope
          subType: anonymous
          subComponents: { }
          config: { }
        - id: ba4b8c20-247e-422a-a2c7-b7a173921d7b
          name: Max Clients Limit
          providerId: max-clients
          subType: anonymous
          subComponents: { }
          config:
            max-clients:
              - '200'
        - id: 006b4994-45a6-401f-9c9c-edcae565144e
          name: Allowed Protocol Mapper Types
          providerId: allowed-protocol-mappers
          subType: authenticated
          subComponents: { }
          config:
            allowed-protocol-mapper-types:
              - oidc-usermodel-attribute-mapper
              - oidc-usermodel-property-mapper
              - saml-user-attribute-mapper
              - oidc-full-name-mapper
              - saml-user-property-mapper
              - oidc-address-mapper
              - saml-role-list-mapper
              - oidc-sha256-pairwise-sub-mapper
        - id: 01d966a1-e26d-4bfd-8ebd-a2639d93531b
          name: Trusted Hosts
          providerId: trusted-hosts
          subType: anonymous
          subComponents: { }
          config:
            host-sending-registration-request-must-match:
              - 'true'
            client-uris-must-match:
              - 'true'
      org.keycloak.keys.KeyProvider:
        - id: 8ce6ba2f-a300-4af6-9632-3c0f46e70e97
          name: rsa-enc-generated
          providerId: rsa-enc-generated
          subComponents: { }
          config:
            priority:
              - '100'
            algorithm:
              - RSA-OAEP
        - id: e8fa5355-4333-4c33-946d-4014d91a2303
          name: aes-generated
          providerId: aes-generated
          subComponents: { }
          config:
            priority:
              - '100'
        - id: 792f9580-aa54-46b7-a868-f21ac3d4c90a
          name: hmac-generated
          providerId: hmac-generated
          subComponents: { }
          config:
            priority:
              - '100'
            algorithm:
              - HS256
        - id: 1b103a4d-2cc0-43b2-981e-2fb3837b371c
          name: rsa-generated
          providerId: rsa-generated
          subComponents: { }
          config:
            priority:
              - '100'
    internationalizationEnabled: false
    supportedLocales: [ ]
    authenticationFlows:
      - id: ef216d95-5772-4b36-97c0-457fc2bac849
        alias: Account verification options
        description: Method with which to verity the existing account
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: idp-email-verification
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: ALTERNATIVE
            priority: 20
            autheticatorFlow: true
            flowAlias: Verify Existing Account by Re-authentication
            userSetupAllowed: false
      - id: 00916ee2-7218-4cdf-93bf-7a810e5fdea6
        alias: Browser - Conditional OTP
        description: Flow to determine if the OTP is required for the authentication
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: conditional-user-configured
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: auth-otp-form
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
      - id: c809134c-70b4-4566-9476-a98b4619aee0
        alias: Direct Grant - Conditional OTP
        description: Flow to determine if the OTP is required for the authentication
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: conditional-user-configured
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: direct-grant-validate-otp
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 6c0b4ffc-cd8c-4330-adfc-f2120cb00253
        alias: First broker login - Conditional OTP
        description: Flow to determine if the OTP is required for the authentication
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: conditional-user-configured
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: auth-otp-form
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 6370b0eb-33ca-4242-8bcd-6153381902bf
        alias: Handle Existing Account
        description: >-
          Handle what to do if there is existing account with same email/username
          like authenticated identity provider
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: idp-confirm-link
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: true
            flowAlias: Account verification options
            userSetupAllowed: false
      - id: 6f138076-7b6b-46a1-abf7-6eceddfbff59
        alias: Reset - Conditional OTP
        description: >-
          Flow to determine if the OTP should be reset or not. Set to REQUIRED to
          force.
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: conditional-user-configured
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: reset-otp
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 7f37c921-0588-470e-b87d-ce51647b0a41
        alias: User creation or linking
        description: Flow for the existing/non-existing user alternatives
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticatorConfig: create unique user config
            authenticator: idp-create-user-if-unique
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: ALTERNATIVE
            priority: 20
            autheticatorFlow: true
            flowAlias: Handle Existing Account
            userSetupAllowed: false
      - id: 4fd154ae-66f9-4846-8940-a2eb152bf009
        alias: Verify Existing Account by Re-authentication
        description: Reauthentication of existing account
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: idp-username-password-form
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: CONDITIONAL
            priority: 20
            autheticatorFlow: true
            flowAlias: First broker login - Conditional OTP
            userSetupAllowed: false
      - id: d0083fa6-7bb3-4db7-9e13-29624eec74f2
        alias: browser
        description: browser based authentication
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: auth-cookie
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: auth-spnego
            authenticatorFlow: false
            requirement: DISABLED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: identity-provider-redirector
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 25
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: ALTERNATIVE
            priority: 30
            autheticatorFlow: true
            flowAlias: forms
            userSetupAllowed: false
      - id: b29aace5-fd85-4a2d-82ac-58c89996ab86
        alias: clients
        description: Base authentication for clients
        providerId: client-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: client-secret
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: client-jwt
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: client-secret-jwt
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 30
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: client-x509
            authenticatorFlow: false
            requirement: ALTERNATIVE
            priority: 40
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 5c2d2538-d64d-43ae-af92-1ac431d9630b
        alias: direct grant
        description: OpenID Connect Resource Owner Grant
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: direct-grant-validate-username
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: direct-grant-validate-password
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: CONDITIONAL
            priority: 30
            autheticatorFlow: true
            flowAlias: Direct Grant - Conditional OTP
            userSetupAllowed: false
      - id: 2bd03c2c-4e00-4b28-9b35-de237cdf8b3d
        alias: docker auth
        description: Used by Docker clients to authenticate against the IDP
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: docker-http-basic-authenticator
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 5b0d2f4b-81aa-4d2a-8993-b9b118b081e6
        alias: first broker login
        description: >-
          Actions taken after first broker login with identity provider account,
          which is not yet linked to any Keycloak account
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticatorConfig: review profile config
            authenticator: idp-review-profile
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: true
            flowAlias: User creation or linking
            userSetupAllowed: false
      - id: 915d80e0-79a8-4aeb-8868-4b4d7e758452
        alias: forms
        description: 'Username, password, otp and other auth forms.'
        providerId: basic-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: auth-username-password-form
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: CONDITIONAL
            priority: 20
            autheticatorFlow: true
            flowAlias: Browser - Conditional OTP
            userSetupAllowed: false
      - id: a49c6cbf-5de7-4cb2-8621-68c9e3544b36
        alias: registration
        description: registration flow
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: registration-page-form
            authenticatorFlow: true
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: true
            flowAlias: registration form
            userSetupAllowed: false
      - id: 641b9378-7b37-41eb-9ae8-155ced487f62
        alias: registration form
        description: registration form
        providerId: form-flow
        topLevel: false
        builtIn: true
        authenticationExecutions:
          - authenticator: registration-user-creation
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: registration-profile-action
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 40
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: registration-password-action
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 50
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: registration-recaptcha-action
            authenticatorFlow: false
            requirement: DISABLED
            priority: 60
            autheticatorFlow: false
            userSetupAllowed: false
      - id: 7d4c13d3-ecbf-4eb7-b3a1-97c6098fbb23
        alias: reset credentials
        description: Reset credentials for a user if they forgot their password or something
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: reset-credentials-choose-user
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: reset-credential-email
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 20
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticator: reset-password
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 30
            autheticatorFlow: false
            userSetupAllowed: false
          - authenticatorFlow: true
            requirement: CONDITIONAL
            priority: 40
            autheticatorFlow: true
            flowAlias: Reset - Conditional OTP
            userSetupAllowed: false
      - id: 1353f39e-ba02-4e74-966b-97606ca24724
        alias: saml ecp
        description: SAML ECP Profile Authentication Flow
        providerId: basic-flow
        topLevel: true
        builtIn: true
        authenticationExecutions:
          - authenticator: http-basic-authenticator
            authenticatorFlow: false
            requirement: REQUIRED
            priority: 10
            autheticatorFlow: false
            userSetupAllowed: false
    authenticatorConfig:
      - id: 75c3a3a0-8b72-4754-bd4d-6226552b63c5
        alias: create unique user config
        config:
          require.password.update.after.registration: 'false'
      - id: c9000224-5df1-48ed-9c5e-8c569528eb71
        alias: review profile config
        config:
          update.profile.on.first.login: missing
    requiredActions:
      - alias: CONFIGURE_TOTP
        name: Configure OTP
        providerId: CONFIGURE_TOTP
        enabled: true
        defaultAction: false
        priority: 10
        config: { }
      - alias: TERMS_AND_CONDITIONS
        name: Terms and Conditions
        providerId: TERMS_AND_CONDITIONS
        enabled: false
        defaultAction: false
        priority: 20
        config: { }
      - alias: UPDATE_PASSWORD
        name: Update Password
        providerId: UPDATE_PASSWORD
        enabled: true
        defaultAction: false
        priority: 30
        config: { }
      - alias: UPDATE_PROFILE
        name: Update Profile
        providerId: UPDATE_PROFILE
        enabled: true
        defaultAction: false
        priority: 40
        config: { }
      - alias: VERIFY_EMAIL
        name: Verify Email
        providerId: VERIFY_EMAIL
        enabled: true
        defaultAction: false
        priority: 50
        config: { }
      - alias: delete_account
        name: Delete Account
        providerId: delete_account
        enabled: false
        defaultAction: false
        priority: 60
        config: { }
      - alias: webauthn-register
        name: Webauthn Register
        providerId: webauthn-register
        enabled: true
        defaultAction: false
        priority: 70
        config: { }
      - alias: webauthn-register-passwordless
        name: Webauthn Register Passwordless
        providerId: webauthn-register-passwordless
        enabled: true
        defaultAction: false
        priority: 80
        config: { }
      - alias: update_user_locale
        name: Update User Locale
        providerId: update_user_locale
        enabled: true
        defaultAction: false
        priority: 1000
        config: { }
    browserFlow: browser
    registrationFlow: registration
    directGrantFlow: direct grant
    resetCredentialsFlow: reset credentials
    clientAuthenticationFlow: clients
    dockerAuthenticationFlow: docker auth
    attributes:
      cibaBackchannelTokenDeliveryMode: poll
      cibaExpiresIn: '120'
      cibaAuthRequestedUserHint: login_hint
      oauth2DeviceCodeLifespan: '600'
      oauth2DevicePollingInterval: '5'
      parRequestUriLifespan: '60'
      cibaInterval: '5'
      realmReusableOtpCode: 'false'
    keycloakVersion: 22.0.5
    userManagedAccessAllowed: false
    clientProfiles:
      profiles: [ ]
    clientPolicies:
      policies: [ ]
YAML
}
