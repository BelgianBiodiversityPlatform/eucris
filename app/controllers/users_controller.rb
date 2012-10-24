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

    respond_to do |format|
      if @user.save
        format.html  { redirect_to(@user,
                      :notice => 'User was successfully created.') }
        format.json  { render :json => @user,
                      :status => :created, :location => @user }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @user.errors,
                      :status => :unprocessable_entity }
      end
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
end
