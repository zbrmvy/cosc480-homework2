# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
    @filter = Movie.ratings
    @movies = Movie.all
    @all_ratings = Movie.ratings
    key_array = Movie.ratings
    if session[:sort] != nil or session[:ratings] != nil
      redirect_to("/sort/#{session[:sort]}")
    end
    if session[:ratings] == nil
      session[:ratings] = Movie.ratings
    end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
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

  def sort
    if params[:ratings] == nil and session[:ratings] != nil
	key_array = session[:ratings]
        @movies = Movie.where(:rating => key_array)
        @filter = key_array
        @all_ratings = Movie.ratings
    end
    if params[:sort] == nil and session[:sort] != nil
	params[:sort] = session[:sort]
    end
    if params[:ratings] != nil
	key_array = []
      params[:ratings].each do |key,value|
        key_array.push(key)
      end
      session[:ratings] = key_array
      @movies = Movie.where(:rating => key_array)
      @filter = key_array
      @all_ratings = Movie.ratings
      if params[:sort].nil?
        render 'index'
      end
    end
    if params[:sort] == 'title'
      session[:sort] = 'title' 
      if @movies
        @movies = @movies.order('title')
      else
        @movies = Movie.find(:all, :order => 'title')
      end
      @sortv = 'title'
      @all_ratings = Movie.ratings
      render 'index'
    elsif params[:sort] == 'date'
      session[:sort] = 'date'
      if @movies
        @movies = @movies.order('release_date')
      else
        @movies = Movie.find(:all, :order => 'release_date')
      end
      @sortv = 'date'
      @all_ratings = Movie.ratings
      render 'index'
    else
      @movies = Movies.all
      @sortv = ""
    end
  end
end
