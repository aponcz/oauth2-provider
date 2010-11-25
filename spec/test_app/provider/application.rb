require 'sinatra'

module TestApp
  class Provider < Sinatra::Base
    
    extend Helper::RackRunner
    
    set :views, File.dirname(__FILE__) + '/views'
    
    def handle_authorize
      @oauth2 = OAuth2::Provider.parse(User['Bob'], request)
      redirect @oauth2.redirect_uri if @oauth2.redirect?
      
      headers @oauth2.response_headers
      status  @oauth2.response_status
      
      @oauth2.response_body || erb(:authorize)
    end
    
    def serve_protected_resource
      @user = User['Bob']
      @auth = OAuth2::Provider.access_token(request)
      if @user.grants_access?(@auth, 'profile')
        JSON.unparse('data' => 'Top secret')
      else
        JSON.unparse('data' => 'No soup for you')
      end
    end
    
    [:get, :post].each do |method|
      __send__(method, '/authorize') { handle_authorize }
    end
    
    post '/allow' do
      @user = User['bob']
      @oauth2 = OAuth2::Provider::Authorization.new(@user, params)
      if params['allow'] == '1'
        @oauth2.grant_access!
      else
        @oauth2.deny_access!
      end
      redirect @oauth2.redirect_uri
    end
    
    [:get, :post].each do |method|
      __send__ method, '/me' do
        access_token = OAuth2::Provider.access_token(request)
        if access_token
          JSON.unparse('data' => access_token.owner.name)
        else
          JSON.unparse('data' => 'No soup for you')
        end
      end
      
      __send__(method, '/user_profile') { serve_protected_resource }
    end
    
  end
end

