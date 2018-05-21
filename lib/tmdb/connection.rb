require 'faraday'
require 'json'

# Setup the Faraday Connection
class Connection
    BASE = "https://api.themoviedb.org"

    def self.api
        Faraday.new(url: BASE) do |faraday|
            # Form-encode POST params
            faraday.request  :url_encoded             

            # Filter sensitive information from logs with a regex matcher
            faraday.response :logger do | logger |
              logger.filter(/(api_key=)(\w+)/,'\1[REMOVED]')
            end

            # Make requests with Net::HTTP
            faraday.adapter  Faraday.default_adapter  
        end
    end
end