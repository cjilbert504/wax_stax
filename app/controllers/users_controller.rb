class UsersController < ApplicationController
  
  get "/users" do
    @users = User.all 
    erb :"/users/index.html"
  end
  
  get "/signup/new" do
    if is_logged_in?
      flash[:error] = "***You already have an account and are logged in***"
      redirect to "/users/#{current_user.id}"
    else
      erb :"/users/new.html"
    end
  end

  post "/users" do
    if params[:username].empty? || params[:password].empty?
      flash[:error] = "***One or more fields was left empty. Please try again***"
      redirect to '/signup/new'
    elsif user = User.find_by(:username => params[:username])
      flash[:error] = "***Username is already taken***"
      redirect to '/signup/new'
    else
      user = User.create(params)
      session[:user_id] = user.id
      flash[:success] = "SUCCESS!"
      redirect to "/users/#{user.id}"
    end
  end

  get "/users/collections/:id" do
    find_and_set_user
    @collection = @user.vinyl_records
    erb :"/users/collection.html"
  end

  get "/login" do
    if is_logged_in?
      flash[:error] = "***You are already logged in***"
      redirect to "/users/#{current_user.id}"
    else
      erb :"/users/login.html"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully logged in!"
      redirect to "/users/#{user.id}"
    end
    flash[:error] = "***Invalid username or password, please try again***"
    redirect to "/login"
  end

  get "/logout" do
    if session[:user_id] != nil
      session.clear
      redirect to "/"
    end
  end

  get "/users/:id" do
    if is_logged_in?
      find_and_set_user
      erb :"/users/show.html"
     else 
      flash[:error] = "***You are not logged in***"
      redirect to "/"
    end
  end

  get "/users/:id/edit" do
    if is_logged_in?
      find_and_set_user
      erb :"/users/edit.html"
    else
      flash[:error] = "***You do not have that permission***"
      redirect to "/"
    end
  end

  patch "/users/:id" do
    find_and_set_user
    if @user.authenticate(params[:password]) && !params[:username].empty?
      @user.update(:username => params[:username], :password => params[:password])
      flash[:success] = "Account Updated!"
      redirect to "/users/#{@user.id}"
    end
    flash[:error] = "***Invalid Username or Password***"
    redirect to "/users/#{@user.id}/edit"
  end

  delete "/users/:id" do
    find_and_set_user
    @user.destroy
    session.clear
    flash[:success] = "YOUR ACCOUNT HAS BEEN DELETED!!!"
    redirect "/"
  end

  private

  def find_and_set_user
    @user = User.find_by(:id => params[:id])
  end

end
