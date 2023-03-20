class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    
    if params[:locale]
      session[:locale] = params[:locale]
    end

    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
