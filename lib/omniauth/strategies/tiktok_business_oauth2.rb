module OmniAuth
  module Strategies
    class TiktokBusinessOauth2 < OmniAuth::Strategies::OAuth2
      USER_INFO_URL = 'https://business-api.tiktok.com/open_api/v1.3/business/get/'
      USER_FIELDS = '["username","display_name","profile_image","is_business_account"]'

      option :name, "tiktok_business_oauth2"
      option :client_options,
             site: 'https://business-api.tiktok.com/',
             authorize_url: 'https://www.tiktok.com/v2/auth/authorize/',
             token_url: 'https://business-api.tiktok.com/open_api/v1.3/tt_user/oauth2/token/'

      option :pkce, true

      def authorize_params
        super.tap do |params|
          params[:client_key] = options.client_id
        end
      end

      uid do
        raw_info['open_id']
      end

      info do
        {
          id: raw_info['open_id'],
          name: raw_info['user']['display_name'],
          username: raw_info['user']['username'],
          profile_image: raw_info['user']['profile_image'],
          is_business_account: raw_info['user']['is_business_account']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      # # Remove params as callback URL must match exactly the URL defined for the application
      def callback_url
        super.split('?').first
      end

      def token_params
        options.token_params.merge(
          headers: { 'Content-Type' => 'application/json' },
          client_id: options.client_id,
          client_secret: options.client_secret,
          auth_code: request.params["code"],
          parse: :tiktok_business,
        )
      end

      def raw_info
        @raw_info ||= access_token_info.merge('user' => tiktok_user_info)
      end

      def tiktok_user_info
        @tiktok_user_info ||= begin
          headers = {
            'Access-Token' => access_token.token
          }

          params = {
            business_id: access_token_info['open_id'],
            fields: USER_FIELDS
          }
          
          access_token.get(USER_INFO_URL, headers: headers, params: params, parse: :tiktok_business).parsed
        end
      end

      def access_token_info
        access_token.to_hash.stringify_keys
      end

      # It is necessary to override this method to avoid the "Content-Type" string getting turned into a symbol.
      # Unfortunately you can't just pass headers in `token_params` method because the original `build_access_token` deep symbolizes all parameters, and the OAuth2 gem expects the headers to be strings
      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params), deep_symbolize(options.auth_token_params))
      end

    end
  end
end