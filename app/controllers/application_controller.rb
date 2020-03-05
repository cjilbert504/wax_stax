require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "diggingthroughcrates"
  end

  get "/" do
    erb :index
  end

  helpers do

    def is_logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def edit_delete_allowed?(find_and_set_vinyl_record)
      if is_logged_in?
        if find_and_set_vinyl_record.user == current_user
          true
        else
          false
        end
      else
        false
      end
    end 

  end

end
