require 'net/http'
require 'uri'
require 'json'

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def search_tmdb
    # tmdb api
    tmdb_api = URI("https://api.themoviedb.org/3/search/movie?api_key=dc72c1f2b08c877266ab76b491c65f53&query=#{params[:search_terms]}")
    # get response from tmdb api 
    tmdb_res = Net::HTTP.get_response(tmdb_api)

    # database as json format
    tmdb_db = JSON.parse(tmdb_res.body)
    
    # check if data input not in database TMDb
    if tmdb_db["errors"] || tmdb_db["results"] == []
      flash[:notice] = "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path

    # found data input in database TMDb
    else
      tmdb_title  = tmdb_db["results"][0]["original_title"]
      tmdb_rating = tmdb_db["results"][0]["adult"]
      tmdb_date   = tmdb_db["results"][0]["release_date"]
      tmdb_info   = tmdb_db["results"][0]["overview"]
      
      # send data to .haml
      @movie = {
        "title" => tmdb_title,
        "adult" => tmdb_rating,
        "date" => tmdb_date,
        "info" => tmdb_info
      }

      redirect_to new_movie_path(@movie)

    end
  end

end
