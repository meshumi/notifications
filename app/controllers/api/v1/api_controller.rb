module Api
  module V1
    class ApiController < ApplicationController
      protect_from_forgery with: :null_session
      # before_action :check_token

      private

      def check_token
        return true
        render_token_error
      end

      def render_token_error
        render json: {
          errors: [{ status: 401,
                     detail: I18n.t('devise_token_auth.sessions.bad_credentials') }]
        }, status: 401
      end
    end
  end
end
