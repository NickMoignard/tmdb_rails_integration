
module TMDB
    def self.search(options = {})
        raise ArgumentError, 'You must search for something' if options[:query].blank?
        
        options = options.merge({ :api_key => API_KEY  })

        query_string = options.map{ |k,v| "#{k}=#{v}"}.join("&")
        path = "/3/search/movie?#{query_string}" 

        response = Request.api.get(path)
    end

    def errors(response)
        error = { errors: { status: response["status"], message: response["message"] } }
        response.merge(error)
    end

    class Base
        attr_accessor :errors

        # if the reader is confused by below - google "ruby metaprogramming"
        def initialize(args = {})
            args.each do |key, value|
                attr_name = key.to_s.underscore
                # call set all the data members for an object
                if respond_to?("#{attr_name}=")
                    send("#{attr_name}=", value) 
                end
            end
        end
    end

    class Search < Base
	    attr_accessor   :page,
			            :total_results,
			            :total_pages,
                        :results
                        
                        
        def initialize(query)
            raise ArgumentError 'Query must be a String' if !query.is_a?(String)

            response = TMDB::search(:query => query)
            json = JSON.parse(response.body)
            super(json)

            self.results = parse_results(json)
        end

        def parse_results(json)
            json.fetch("results", []).map { |movie| TMDB::Movie.new(movie) }
        end
    end

    class Movie < Base
		attr_accessor 	:vote_count,
						:id,
						:video,
						:vote_average,
						:title,
						:popularity,
						:poster_path,
						:original_language,
						:original_title,
						:genre_ids,
						:backdrop_path,
						:adult,
						:overview,
						:release_date

		def adult?
			@adult
        end
	end
end

