class VinylRecordsController < ApplicationController

  get "/vinyl_records" do
    @vinyl_records = VinylRecord.all 
    erb :"/vinyl_records/index.html"
  end

  get "/vinyl_records/new" do
    erb :"/vinyl_records/new.html"
  end

  post "/vinyl_records" do
    if !is_logged_in?
      flash[:error] = "***You must be logged in to do this***"
      redirect to "/"
    end
    # if params[:artist].empty? || params[:album].empty? || params[:genre].empty? || params[:release_date].empty?
    if false
      flash[:error] = "***One or more fields left empty, please try again***"
      redirect to "/vinyl_records/new"
    else
      # params[:user_id] = current_user.id
      @vinyl_record = current_user.vinyl_records.build(params)
        if @vinyl_record.save
          flash[:success] = "New Record Succesfully Created!"
          redirect "/vinyl_records/#{@vinyl_record.id}"
        else
          erb :"/vinyl_records/new.html"
        end
    end
  end

  get "/vinyl_records/:id" do
    if find_and_set_vinyl_record
      erb :"/vinyl_records/show.html"
    else 
      redirect to "/"
    end
  end

  get "/vinyl_records/:id/edit" do
    if !is_logged_in?
      flash[:error] = "***You must be logged in to do that***"
      redirect to "/"
    else
      find_and_set_vinyl_record
        if @vinyl_record.user == current_user
          erb :"/vinyl_records/edit.html"
        else
          flash[:error] = "***You do not have the permissions to edit that record***"
          redirect to "/users/#{current_user.id}"
        end
    end
  end

  patch "/vinyl_records/:id" do
    find_and_set_vinyl_record
    if params[:record][:artist].empty? || params[:record][:album].empty? || params[:record][:genre].empty? || params[:record][:release_date].empty?
      flash[:error] = "***One or more fields was left blank***"
      redirect to "/vinyl_records/#{@vinyl_record.id}/edit"
    elsif @vinyl_record.user == current_user
      @vinyl_record.update(params[:record])
      flash[:success] = "Record Successfully Updated!"
      redirect "/vinyl_records/#{@vinyl_record.id}"
    else
      flash[:error] = "***You do not have the permissions to edit that record***"
      redirect to "/users/#{current_user.id}"
    end
  end

  delete "/vinyl_records/:id" do
    if !is_logged_in?
      flash[:error] = "***You must be logged in to do that***"
      redirect to "/"
    else
      find_and_set_vinyl_record
        if @vinyl_record.user == current_user
          @vinyl_record.destroy
          flash[:success] = "Record Successfully Deleted!"
          redirect to "users/#{current_user.id}"
        else
          flash[:error] = "***You do not have the permissions to delete that record***"
          redirect to "/"
        end
    end
  end

  private

  def find_and_set_vinyl_record
    @vinyl_record = VinylRecord.find_by(:id => params[:id])
  end

end
