require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "15bb48d19cb45eeaa5cbadff3d5c27d0dc7cc71bac0371def70ca79bfc0c4e3d"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
