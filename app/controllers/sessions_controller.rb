class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
    @title = "Login"
    flash[:return_to] ||= request.referer
  end


  def create
    user = User.authenticate(params[:session][:login],
                             params[:session][:password])
    if !user.nil?
      # Sign the user in and redirect to the user's show page.
      sign_in user
      #      redirect_to flash[:return_to]
      #    redirect_to search_path
      redirect_to user_path(user)
    else
      # Create an error message and re-render the signin form.
      flash.now[:error] = "Invalid login/password combination."
      @title = "Login"
      render 'new'
    end
  end

  def destroy
    sign_out
#    redirect_to :back
  redirect_to root_path
  end

end
