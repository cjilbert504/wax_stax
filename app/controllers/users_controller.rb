class UsersController < ApplicationController
  
  get "/signup/new" do
    if is_logged_in?
      redirect to "/users/#{current_user.id}"
    else
      erb :"/users/new.html"
    end
  end

  post "/users" do
    if params[:username].empty? || params[:password].empty?
      redirect to '/signup/new'
    end
      user = User.create(params)
      session[:user_id] = user.id
      redirect to "/users/#{user.id}"
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
    find_and_set_user
    erb :"/users/show.html"
  end

  get "/users/:id/edit" do
    find_and_set_user
    erb :"/users/edit.html"
  end

  patch "/users/:id" do
    find_and_set_user
    if @user.authenticate(params[:password])
      @user.update(:username => params[:username], :password => params[:password])
      redirect to "/users/#{@user.id}"
    end
    redirect to "/users/#{@user.id}/edit"
  end

  delete "/users/:id" do
    find_and_set_user
    @user.destroy
    session.clear
    redirect "/"
  end

  private

  def find_and_set_user
    @user = User.find(params[:id])
  end

end
