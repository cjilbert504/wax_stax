class VinylRecordsController < ApplicationController

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
    @vinyl_record = VinylRecord.find(params[:id])
    erb :"/vinyl_records/show.html"
  end

  get "/vinyl_records/:id/edit" do
    @vinyl_record = VinylRecord.find(params[:id])
    erb :"/vinyl_records/edit.html"
  end

  patch "/vinyl_records/:id" do
    @vinyl_record = VinylRecord.find(params[:id])
    @vinyl_record.update(params[:record])
    redirect "/vinyl_records/#{@vinyl_record.id}"
  end

  # DELETE: /vinyl_records/5/delete
  delete "/vinyl_records/:id/delete" do
    redirect "/vinyl_records"
  end
end
