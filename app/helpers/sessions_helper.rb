module SessionsHelper

  def authenticate
    unless session[:token]
      session[:return_to] = request.fullpath
      redirect_to root_path, notice: "Please sign in to access this content."
    end
  end

  def get_clean_subdomain_names(spaces)
    @admin_of = spaces.map do |attributes|
      attributes['space_subdomain']
    end
  end

end
