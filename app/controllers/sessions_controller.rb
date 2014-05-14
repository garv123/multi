class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    session[:token] = auth['credentials']['token']
    spaces = auth['extra']['raw_info']['admin_of']
    get_clean_subdomain_names(spaces)
    unless @admin_of.empty?
      session[:admin_of] = @admin_of
    end

    redirect_to spaces_path
  end

  def failure
    reset_session
    flash[:error] = "Sorry, something went wrong. Please try again."
    redirect_to root_path
  end

  def destroy
    reset_session
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end

end
