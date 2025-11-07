module AlertService
  class Acknowledge < ServiceBase
    attr_reader :alert, :current_user

    def initialize(alert:, current_user:)
      @alert = alert
      @current_user = current_user
    end

    def call
      return self unless acknowledge_alert

      self
    end

    def result
      @alert
    end

    private

    def acknowledge_alert
      alert.acknowledge!(current_user)
      true
    rescue StandardError => e
      add_error("Failed to acknowledge alert: #{e.message}")
      false
    end
  end
end
