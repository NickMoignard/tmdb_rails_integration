class SearchController < ApplicationController
    
    def index
        if params[:movie] && !params[:movie].empty?
            search = TMDB::Search.new(params[:movie].to_s)
            @movies = search.results
        else    
            @movies = []
        end
    end

    def show
        @movie = TMDB::Movie.find(params[:id])
    end

    private

    def search_params
        params.require(:movie).permit(:movie)
    end
end