module Omniauthable
  extend ActiveSupport::Concern

  included do
    has_many :authorizations, dependent: :destroy

    def self.credentials_valid?(auth)
      return auth.try(:provider) && auth.try(:uid)
    end

    def self.find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      return nil unless auth.info.try(:email)

      email = auth.info[:email]
      user = User.where(email: email).first
      
      if user
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth)
      end
      user
    end

    def create_authorization(auth)
      self.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
  end
end
