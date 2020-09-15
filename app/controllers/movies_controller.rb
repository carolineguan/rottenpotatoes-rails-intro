class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = (params[:ratings].present? ? params[:ratings] : [])
    @all_ratings = Movie.all_ratings
    needRedirect = false
    @nameDate = nil
    @ratings = nil
    
    if !params[:nameDate].nil?
      session[:nameDate] = params[:nameDate]
    
    elsif !session[:nameDate].nil?
      needRedirect = true  
    end
    @nameDate = session[:nameDate]
    
    if params[:commit] == 'Refresh' && params[:ratings].nil?
      @ratings = session[:ratings]
    
    elsif !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    
    elsif !session[:ratings].nil?
      needRedirect = true
    end
    @ratings = session[:ratings]


    if needRedirect
      flash.keep
      redirect_to movies_path :nameDate=>@nameDate, :ratings=>@ratings
    end

    
    if @ratings && @nameDate 
      @movies = Movie.where(:rating => @ratings.keys).order(@nameDate)
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    elsif @nameDate
      @movies = Movie.order(@nameDate)
    else 
      @movies = Movie.all
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    needRedirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    needRedirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    needRedirect_to movies_path
  end



end
