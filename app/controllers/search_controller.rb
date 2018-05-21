class SearchController < ApplicationController
    def index
    end

    def show
        @movie = TMDB::Movie.find(params[:id])
    end

    private
    def query
        params.fetch(:query, {})
    end
end