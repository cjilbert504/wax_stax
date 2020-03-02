class VinylRecordsController < ApplicationController

  # GET: /vinyl_records
  get "/vinyl_records" do
    erb :"/vinyl_records/index.html"
  end

  get "/vinyl_records/new" do
    erb :"/vinyl_records/new.html"
  end

  # POST: /vinyl_records
  post "/vinyl_records" do
    redirect "/vinyl_records"
  end

  # GET: /vinyl_records/5
  get "/vinyl_records/:id" do
    erb :"/vinyl_records/show.html"
  end

  # GET: /vinyl_records/5/edit
  get "/vinyl_records/:id/edit" do
    erb :"/vinyl_records/edit.html"
  end

  # PATCH: /vinyl_records/5
  patch "/vinyl_records/:id" do
    redirect "/vinyl_records/:id"
  end

  # DELETE: /vinyl_records/5/delete
  delete "/vinyl_records/:id/delete" do
    redirect "/vinyl_records"
  end
end
