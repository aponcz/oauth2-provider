module OAuth2
  module Model
    autoload :ClientOwner,   ROOT + '/oauth2/model/client_owner'
    autoload :ResourceOwner, ROOT + '/oauth2/model/resource_owner'
    autoload :Hashing,       ROOT + '/oauth2/model/hashing'
    autoload :Authorization, ROOT + '/oauth2/model/authorization'
    autoload :Client,        ROOT + '/oauth2/model/client'
    autoload :Schema,        ROOT + '/oauth2/model/schema'

    def self.find_access_token(access_token)
      Authorization.where({ :access_token_hash => OAuth2.hashify(access_token) }).first
    end
  end
end

