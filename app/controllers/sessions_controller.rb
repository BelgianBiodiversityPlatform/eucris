class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
    @title = "Login"
    flash[:return_to] ||= request.referer
  end

  def create
    user = User.authenticate(params[:session][:login],
                             params[:session][:password])
    if user.nil?
      # Create an error message and re-render the signin form.
      flash.now[:error] = "Invalid login/password combination."
      @title = "Login"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
      sign_in user
#      redirect_to flash[:return_to]
    redirect_to search_path
    end
  end

  def destroy
    sign_out
    redirect_to :back
  end

end
