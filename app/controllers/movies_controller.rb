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
    # get a list of values of ratings
    @all_ratings = Movie.all_ratings

    # if params is empty then populate it with either the session or check all
    if params[:ratings].nil? || params[:ratings].empty?
      params[:ratings] = session[:ratings] || Hash[@all_ratings.map{ |rating| [rating, true]}]
      flash.keep
      redirect_to movies_path(params)
    end

    # update the session ratings
    session[:ratings] = params[:ratings]
    @ratings = session[:ratings]

    # determine which columns need to be sorted if any
    session[:sort] =  params[:sort] || session[:sort]
    sort = session[:sort]
    css_highlight = "hilite bg-warning"

    # get movies that pass the filter
    @movies = Movie.with_rating(@ratings.keys)

    # set order and highlight based on input
    if sort == "title"
      @movies = @movies.order(:title)
      @highlight_title = css_highlight
    elsif sort == "release_date"
      @movies = @movies.order(:release_date)
      @highlight_release_date = css_highlight
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
