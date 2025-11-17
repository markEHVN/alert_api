class BlogSerializer
  include JSONAPI::Serializer

  attributes :title, :content

  attributes :author_id do |blog|
    blog.user_id
  end

  # N+1 problems
  attribute :author_name do |blog|
    blog.user.first_name + " " + blog.user.last_name
  end
end
