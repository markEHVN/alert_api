# Ruby on Rails flow

```ruby
config.ru -> config/environment -> application

This is a Rack configuration file (`.ru` stands for "rackup")

Rack is the interface between your Rails app and the web server

Rails app <- Rack -> Web server

run Rails.application` tells the server to run your Rails app
```

## Purpose

### config.ru

Load config/environment: `require_relative config/environment`
Tells the server to run your Rails app `run Rails.application`

### config/environment

Load the Rails application `require_relative application`

### application.rb

Setup Gem: `require_relative boot`

```ruby
module ApplicationName
  class Application << Rails::Application
  end
end
```

### routes.rb

Defined your application route. The Rails router matches incoming HTTP requests to specific controller actions in your Rails application based on the URL path.

Namespace help organize groups of controllers under a namespace.

## Model

ApplicationRecord - The Base Class
ApplicationRecord inherits from ActiveRecord::Base -> gives all models database functionality (ORM - Object Relationship Mapping)

### User Model

### Alert Model

### AlertSubscription Model
