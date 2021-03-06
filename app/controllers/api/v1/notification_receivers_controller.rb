module Api
  module V1
    class NotificationReceiversController < ApiController
      def create
        record = NotificationReceiver.find_or_initialize_by(simplify_params)

        if record.persisted?
          head :ok, content_type: :json
        elsif record.save
          render json: :created, status: :ok
        else
          render json: record.errors.first, status: :unprocessable_entity
        end
      end

      private

      def notification_receiver_params
        params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
      end

      def simplify_params
        simplify_params = {
          endpoint: notification_receiver_params[:endpoint],
          p256dh: notification_receiver_params[:keys][:p256dh],
          auth: notification_receiver_params[:keys][:auth]
        }
        simplify_params
      end
    end
  end
end
