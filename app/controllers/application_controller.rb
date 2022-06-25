class ApplicationController < ActionController::Base
  before_action :authorise

  def authorise
    session[:source_id] = Source.find_by(token: params[:token]).id if params[:token]
    return if session[:source_id]

    head 401
  end

  def source_id
    session[:source_id]
  end
end
