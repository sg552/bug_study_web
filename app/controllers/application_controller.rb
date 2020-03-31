class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def currency
    "#{params[:ask]}#{params[:bid]}".to_sym
  end

  def redirect_back_or_settings_page
    if cookies[:redirect_to].present?
      redirect_to URI.parse(cookies[:redirect_to]).path
      cookies[:redirect_to] = nil
    else
      redirect_to settings_path
    end
  end

  # for devise
  #alias_method :current_user, :current_member
  def current_user
    # for cas:
    @current_user ||= current_manager
  end

end
