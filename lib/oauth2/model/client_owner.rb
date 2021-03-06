module OAuth2
  module Model

    module ClientOwner
      def self.included(receiver)
        receiver.class_eval do
          has_many  :auth2_clients,
                    :class_name => 'OAuth2::Model::Client',
                    :as => :oauth2_client_owner

        end
      end
    end

  end
end
