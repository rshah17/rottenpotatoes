class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sortAttr = params[:sortBy]
    if sortAttr == nil
      sortAttr = session[:sortAttr]
    else
      session[:sortAttr] = sortAttr
    end
    
    @highlight = {:title => nil, :release_date => nil}
    if params[:ratings]
      @movies = Movie.find(:all, :conditions=>{rating: params[:ratings].keys},:order=>sortAttr) 
      @all_ratings = {'G'=> true, 'PG'=>true, 'PG-13'=>true, 'R'=>true}
      allUnchecked = true
      @all_ratings.keys.each {|checkedRating|
        if !(params[:ratings].keys.include?(checkedRating))
          @all_ratings[checkedRating] = false
        else
          @all_ratings[checkedRating] = true
          allUnchecked = false
        end
      }
      if allUnchecked
        @all_ratings = session[:ratings]
      end
      session[:ratings] = @all_ratings
    else
      @all_ratings = session[:ratings]
      if !@all_ratings
        @all_ratings = {'G'=> true, 'PG'=>true, 'PG-13'=>true, 'R'=>true}
      end
      @movies = Movie.find(:all,:conditions=> {rating: @all_ratings.keys}, :order=>sortAttr)
    end
    if sortAttr
      if sortAttr == 'title'
        @highlight[:title] = 'hilite'
      else
        @highlight[:release_date] = 'hilite'
      end
    end
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

end
