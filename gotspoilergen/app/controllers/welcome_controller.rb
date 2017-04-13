class WelcomeController < ApplicationController
  require "uri"
  require "net/http"

  def index
    uriAPI = 'http://gotspoilergenwebservice.herokuapp.com/api_rest/index.json'
  	if(enc_uri_is_set)
	  	peopleId, placesId, thingsId = self.params_decode
	  	if(!peopleId.nil? && !placesId.nil? && !thingsId.nil?)
  		  paramsAPI = {'auth_request_key' => '62b15f01097ad285ca8162829afa86ae',
  					   'command' => 'get_selected_values',
  					   'idPeople' => peopleId,
  					   'idThings' => thingsId,
  					   'idPlaces' => placesId}
  		  resposta_http = Net::HTTP.post_form(URI.parse(uriAPI), paramsAPI)
  		  @parsed_json = JSON.parse(resposta_http.body)
	  	end
  	else
		  paramsAPI = {'auth_request_key' => '62b15f01097ad285ca8162829afa86ae',
					   'command' => 'get_one_random_string'}

		  resposta_http = Net::HTTP.post_form(URI.parse(uriAPI), paramsAPI)
		  @parsed_json = JSON.parse(resposta_http.body)
  	end	
  end

  def params_decode
  	if(params.has_key?(:enc_uri))
  		strUri = params[:enc_uri]
  		strUri = strUri.sub("xZ3", "!") 
  		strUri = strUri.sub("p3x", "!")
  		strUri = strUri.sub("m12", "!")

  		index_of = strUri.index("!",1)
  		peopleNumber = strUri[1..index_of-1] 
  		index_ini = index_of+1	
  		index_of = strUri.index("!",index_ini	)
  		placesNumber = strUri[index_ini..index_of-1]
  		index_ini = index_of+1
  		thingsNumber = strUri[index_ini..strUri.length]

  		return peopleNumber.to_i, placesNumber.to_i, thingsNumber.to_i
   	else
  		return nil
  	end
  end

  def enc_uri_is_set
  	if(params.has_key?(:enc_uri))
  	  return true
  	else
  	  return false
  	end
  end
end
