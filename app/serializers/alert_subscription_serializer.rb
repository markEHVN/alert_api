class AlertSubscriptionSerializer
  include JSONAPI::Serializer

  attributes :id, :notification_method, :is_active
end
