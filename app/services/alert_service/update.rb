module AlertService
  class Update < ServiceBase
    attr_reader :alert, :params

    def initialize(alert:, params:)
      @params = params
      @alert = alert
    end

    def call
      return self unless update_alert

      self
    end

    def result
      @alert
    end

    private

    def update_alert
      if alert.update(params)
        true
      else
        puts "Hello errors"
        add_errors(alert.errors)  # Add ActiveModel::Errors
        false
      end
    end
  end
end
