class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    erb :"/users/index.html"
  end
  
  get "/signup" do
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
    binding.pry 
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/#{user.id}"
    end
    redirect to "/login"
  end

  get "/users/:id" do
    @user = User.find(params[:id])
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
