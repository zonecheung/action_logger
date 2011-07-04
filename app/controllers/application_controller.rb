require "action_logger/base"

class ApplicationController < ActionController::Base
  include ActionLogger::Base

  protect_from_forgery

  before_filter :set_title
  log_request :none

  private

  def set_title
    @title = I18n.t("activerecord.models.action_log")
  end
end
