module AlertService
  class Index < ServiceBase
    attr_reader :params, :alerts, :serializer_options, :current_user

    def initialize(params:, current_user: nil)
      @params = params
      @current_user = current_user
    end

    def call
      include_parts = params[:include].to_s.split(",").map(&:strip)
      # Start with user's alerts if authenticated, otherwise all alerts
      @alerts = current_user ? current_user.alerts : Alert.all
      @alerts = alerts.by_severity(params[:severity]) if params[:severity].present?
      @alerts = alerts.by_category(params[:category]) if params[:category].present?
      @alerts = alerts.unread if params[:unread] == "true"

      # Handle includes vs preload for performance comparison
      if include_parts.include?("user")
        @alerts = alerts.includes(:user)
      end

      if include_parts.include?("subscribers")
        # Compare includes vs preload behavior
        # Use preload to avoid N+1 but don't affect WHERE clauses
        if params[:load_strategy] == "preload"
          Rails.logger.info("[ALERT_API] Using preload(:alert_subscriptions, :user) strategy")
          @alerts = alerts.preload(:alert_subscriptions, :user)
        else
          Rails.logger.info("[ALERT_API] Using includes(:alert_subscriptions, :user) strategy")
          @alerts = alerts.includes(:alert_subscriptions, :user)
        end
      end

      @alerts = alerts
      .recent
      .page(params[:page])
      .per(params[:per_page] || 20)

      # Convert alerts to JSON and send back
      @serializer_options = {}
      @serializer_options[:include_subscribers] = true if include_parts.include?("subscribers")

      self
    end

    def result
      {
        alerts: alerts,
        serializer_options: serializer_options
      }
    end
  end
end
