class KaWelcomeController < ApplicationController
  skip_before_filter :verify_authenticity_token
  layout "ka_application"

  def index
  end
end
