class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :role

  attribute :full_name do |user|
    "#{user.first_name} #{user.last_name}".strip
  end

  # Not N+1 problem, blogs query good with one query
  attribute :blogs do |user|
    user.blogs
  end
end
