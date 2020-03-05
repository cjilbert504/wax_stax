class VinylRecordsController < ApplicationController

  get "/vinyl_records" do
    @vinyl_records = current_user.vinyl_records
    erb :"/vinyl_records/index.html"
  end

  get "/vinyl_records/new" do
    erb :"/vinyl_records/new.html"
  end

  post "/vinyl_records" do
    if !is_logged_in?
      redirect to "/"
    end
    if params[:artist].empty? || params[:album].empty? || params[:genre].empty? || params[:release_date].empty?
      redirect to "/vinyl_records/new"
    else
      params[:user_id] = current_user.id
      vinyl_record = VinylRecord.create(params)
      redirect "/vinyl_records/#{vinyl_record.id}"
    end
  end

  get "/vinyl_records/:id" do
    find_and_set_vinyl_record
    erb :"/vinyl_records/show.html"
  end

  get "/vinyl_records/:id/edit" do
    # find_and_set_vinyl_record
    # if is_logged_in?
    #   if @vinyl_record.user == current_user
    if edit_delete_allowed?(find_and_set_vinyl_record)
        erb :"/vinyl_records/edit.html"
      else
        redirect to "/users/#{current_user.id}"
      end
    # else
    #   redirect to "/"
    # end
  end

  patch "/vinyl_records/:id" do
    # find_and_set_vinyl_record
    # if is_logged_in?
    #   if @vinyl_record.user == current_user
    if edit_delete_allowed?(find_and_set_vinyl_record)
        @vinyl_record.update(params[:record])
        redirect "/vinyl_records/#{@vinyl_record.id}"
      else
        redirect to "/users/#{current_user.id}"
      end
    # else
    #   redirect "/"
    # end
  end

  delete "/vinyl_records/:id" do
    find_and_set_vinyl_record
    if is_logged_in?
      if @vinyl_record.user == current_user
        @vinyl_record.destroy
        redirect to "users/#{current_user.id}"
      else
        redirect to "/vinyl_records/#{@vinyl_record.id}"
      end
    else
      redirect to "/"
    end
  end

  private

  def find_and_set_vinyl_record
    @vinyl_record = VinylRecord.find(params[:id])
  end

end
