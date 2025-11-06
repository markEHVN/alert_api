module AlertService
  class Resolve < ServiceBase
    attr_reader :alert, :current_user

    def initialize(alert:, current_user:)
      @alert = alert
      @current_user = current_user
    end

    def call
      return self unless resolve_alert

      self
    end

    def result
      @alert
    end

    private

    def resolve_alert
      alert.resolve!(current_user)
      true
    rescue StandardError => e
      add_error("Failed to resolve alert: #{e.message}")
      false
    end
  end
end
