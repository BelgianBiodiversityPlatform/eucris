class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.order("familyname, firstname ").all()

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  
  def create
    @user = User.new(params[:user])
    newPassword = @user.password
    @countries = Country.order('name').all()

    if @user.save
          UserMailer.registration_confirmation(@user,newPassword).deliver  
          render 'registration_ok'
    else
        render 'new'
    end
  end

  def new
    @title= "Sign up"
    @user =User.new
    @countries = Country.order('name').all()

    respond_to do |format|
       format.html  # new.html.erb
       format.json  { render :json => @user }
     end
    
  end
  
  def activate_account
    @user = User.find(params[:id])
    if !@user.nil? && @user.update_attribute('activated', true) 
      sign_in @user
      flash[:notice] = "Registration completed. Welcome to BiodivERsA database."
      render 'show'
    else
      flash[:notice] =  "Regsitration failed!"
    end
  end

  def password_reset
  end

  def registration_ok
  end

  def request_new_password
  end

  def generate_and_send_new_password
    @user = User.find_by_login(params[:user][:login])
    if @user.nil?
      flash.now[:error] = "Invalid login, please retry or contact us."
      render 'request_new_password'
    else
      newPassword = (0...8).map{ ('a'..'z').to_a[rand(26)] }.join
      @user.update_attributes(:password => newPassword)
      UserMailer.new_password(@user, newPassword).deliver  
      render 'password_reset'
    end
  end

  
  def chooseSource
    @user = User.find(params[:id])
    if @user.sources.empty?
      @sources= Source.order('origid').all()
    else
      @sources = Source.where(["id NOT IN (?)", @user.sources]).order('origid')
    end
    @source =Source.new

    respond_to do |format|
       format.html  # new.html.erb
       format.json  { render :json => @source }
     end
  end
  
  def addSource
    @user = User.find(params[:id])
    @source = Source.find(params[:source][:id])
    @user.sources<<@source

    redirect_to user_path(@user)
  end

  def deleteSource
    @user = User.find(params[:id])
    @source = Source.find(params[:source_id])
    @user.sources.delete(@source)

    redirect_to user_path(@user)
    
  end
  
end
