# app/services/alert_service/create.rb
module AlertService
  class Create < ServiceBase
    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def call
      return self unless validate_inputs
      return self unless create_alert

      # Send notifications for high severity alerts
      send_notifications if high_severity?
      log_creation

      self  # Always return self (the service instance)
    end

    attr_reader :alert, :params, :current_user

    def result
      @alert
    end

    private

    def validate_inputs
      unless valid_severity?
        add_error("Severity must be low, medium, high, or critical")
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
      AdminMailer.high_severity_alert(@alert).deliver_later
    rescue StandardError => e
      add_error("Failed to send notification: #{e.message}")
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

    def high_severity?
      %w[high critical].include?(params[:severity])
    end

    def valid_severity?
      %w[low medium high critical].include?(params[:severity])
    end
  end
end
