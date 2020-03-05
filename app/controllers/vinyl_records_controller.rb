class VinylRecordsController < ApplicationController

  before "/vinyl_records/:id*" do
    is_logged_in?
  end

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
    if params[:artist].empty? || params[:album].empty? || params[:genre].empty? || params[:release_date].empty?
      flash[:error] = "***One or more fields left empty, please try again***"
      redirect to "/vinyl_records/new"
    else
      params[:user_id] = current_user.id
      vinyl_record = VinylRecord.create(params)
      flash[:success] = "New Record Succesfully Created!"
      redirect "/vinyl_records/#{vinyl_record.id}"
    end
  end

  get "/vinyl_records/:id" do
    find_and_set_vinyl_record
    erb :"/vinyl_records/show.html"
  end

  get "/vinyl_records/:id/edit" do
    find_and_set_vinyl_record
      if @vinyl_record.user == current_user
        erb :"/vinyl_records/edit.html"
      else
        flash[:error] = "***You do not have the permissions to edit that record***"
        redirect to "/users/#{current_user.id}"
      end
  end

  patch "/vinyl_records/:id" do
    find_and_set_vinyl_record
    if @vinyl_record.user == current_user
      @vinyl_record.update(params[:record])
      flash[:success] = "Record Successfully Updated!"
      redirect "/vinyl_records/#{@vinyl_record.id}"
    else
      flash[:error] = "***You do not have the permissions to edit that record***"
      redirect to "/users/#{current_user.id}"
    end
  end

  delete "/vinyl_records/:id" do
    find_and_set_vinyl_record
    if @vinyl_record.user == current_user
      @vinyl_record.destroy
      redirect to "users/#{current_user.id}"
    else
      redirect to "/vinyl_records/#{@vinyl_record.id}"
    end
  end

  private

  def find_and_set_vinyl_record
    @vinyl_record = VinylRecord.find(params[:id])
  end

end
