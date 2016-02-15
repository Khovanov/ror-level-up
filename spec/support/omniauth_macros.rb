module OmniauthMacros
  def mock_auth_hash(provider, email=nil)
    OmniAuth.config.test_mode = true
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.    
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider.to_s,
      uid: '123456',
      info: { email: email }
    })
  end

  def mock_auth_inivalid(provider)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = :invalid_credentials
  end
end
