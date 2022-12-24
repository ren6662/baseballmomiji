class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller? 
  
  def autheniticate_user
    if @current_user==nil
      flash[:notice]="ログインが必要です"
      redirect_to root_path
    end
  end

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,keys:[:email, :image])
    end
end
