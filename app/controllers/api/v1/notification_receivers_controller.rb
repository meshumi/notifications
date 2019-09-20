module Api
  module V1
    class NotificationReceiversController < ApiController
      def create
        record = NotificationReceiver.new(simplify_params)
        record.domain = Domain.find_by(name: params[:domain])
        if record.save
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
