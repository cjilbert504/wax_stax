class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    erb :"/users/index.html"
  end
  
  get "/signup/new" do
    erb :"/users/new.html"
  end

  post "/signup" do
    if params[:username].empty? || params[:password].empty?
      redirect to '/signup'
    end
    @user = User.create(:username => params[:username], :password => params[:password])
    session[:user_id] = @user.id
    redirect "/users/#{@user.id}"
  end

  get "/login" do
    erb :"/users/login.html"
  end

  post "/login" do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/#{user.id}"
    end
    redirect to "/login"
  end

  post "/logout" do
    if session[:user_id] != nil
      session.clear
      redirect to "/login"
    end
    redirect to "/"
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
    @user.update(:username => params[:username])
    redirect to "/users/#{@user.id}"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
