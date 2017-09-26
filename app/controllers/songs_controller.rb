require 'pry'
require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :'songs/new'
  end

  post '/songs' do
    song = Song.create(name: params[:song][:name])
    song.artist = Artist.find_or_create_by(name: params[:song][:artist])

    params[:song][:genre_ids].each do |genre_id|
      song.genres << Genre.find(genre_id)
    end
    song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all
    erb :'songs/edit'
  end

  post '/songs/:slug' do
    song = Song.find_by_slug(params[:slug])
    song.name = params[:song][:name]
    song.artist = Artist.find_or_create_by(name: params[:song][:artist])
    song.genres.clear

    params[:song][:genre_ids].each do |genre_id|
      song.genres << Genre.find(genre_id)
    end
    song.save
    flash[:message] = "Successfully updated song."
    redirect "/songs/#{song.slug}"
  end

end
