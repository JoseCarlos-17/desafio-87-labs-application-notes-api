class ApplicationController < ActionController::API
  include Pagy::Method
  include ErrorHandler
end
