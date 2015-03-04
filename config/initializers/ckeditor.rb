Rails.application.config.assets.precompile += %w( ckeditor/* )

Ckeditor.setup do |config|
  config.assets_languages = ['ru']
end