class PublicErrorsController < ApplicationController

  layout "application"

  def internal_server_error
  end

  def not_found
  end

  def unprocessable_entity
  end

  def conflict
  end

  def method_not_allowed
  end

  def not_implemented
  end
end
