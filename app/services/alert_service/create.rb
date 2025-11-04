# app/services/alert_service/create.rb
module AlertService
  class Create < ServiceBase
    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def call
      return self unless create_alert

      send_notifications if high_priority?
      log_creation

      self  # Always return self (the service instance)
    end

    attr_reader :alert, :params, :current_user

    private

    def validate_inputs
      unless valid_priority?
        add_error("Priority must be low, medium, high, or critical")
        return false
      end

      true
    end

    def create_alert
      @alert = current_user.alerts.build(params)

      if @alert.save
        true
      else
        add_errors(@alert.errors)  # Add ActiveModel::Errors
        false
      end
    end

    def send_notifications
      AdminMailer.high_priority_alert(@alert).deliver_later
    rescue StandardError => e
      add_error("Failed to send notification: #{e.message}")
      # Don't return false - notification failure shouldn't stop the process
    end

    def log_creation
      AuditLog.create!(
        action: "alert_created",
        user: current_user,
        resource: @alert
      )
    rescue StandardError => e
      add_error("Failed to log creation: #{e.message}")
    end

    def high_priority?
      params[:priority] == "high"
    end

    def valid_priority?
      %w[low medium high critical].include?(params[:priority])
    end
  end
end
