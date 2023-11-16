class ApplicationController < ActionController::Base
  around_action :switch_locale

  helper_method :toggle_order

  def toggle_order(column)
    params[:order] == 'asc' ? 'desc' : 'asc'
  end

  def switch_locale(&action)
    
    if params[:locale]
      session[:locale] = params[:locale]
    end

    locale = params[:locale] || session[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: 'No estas autorizado'
  end
end
