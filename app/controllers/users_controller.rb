class UsersController < ApplicationController

  get "/users" do
    @users = User.all
    erb :"/users/index.html"
  end
  
  get "/signup/new" do
    #use is_looged_in? helper instead
    if !session[:user_id]
      erb :"/users/new.html"
    else
    user = User.find(session[:user_id])
    redirect "/users/#{user.id}"
    end
  end

  post "/users" do
    if params[:username].empty? || params[:password].empty?
      redirect to '/signup/new'
    end
    @user = User.create(:username => params[:username], :password => params[:password])
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  end

  get "/login" do
    if is_logged_in?
      redirect to "/users/#{current_user.id}"
    else
      erb :"/users/login.html"
    end
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/#{user.id}"
    end
    redirect to "/login"
  end

  get "/logout" do
    if session[:user_id] != nil
      session.clear
      redirect to "/"
    end
  end

  get "/users/:id" do
    @user = User.find(params[:id])
    erb :"/users/show.html"
  end

  get "/users/:id/edit" do
    @user = User.find(params[:id])
    erb :"/users/edit.html"
  end

  patch "/users/:id" do
    @user = User.find(params[:id])
    if @user.authenticate(params[:password])
      @user.update(:username => params[:username], :password => params[:password])
      redirect to "/users/#{@user.id}"
    end
    redirect to "/users/#{@user.id}/edit"
  end

  delete "/users/:id" do
    @user = User.find(params[:id])
    @user.delete
    session.clear
    redirect "/"
  end
end
