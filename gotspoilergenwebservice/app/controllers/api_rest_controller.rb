class ApiRestController < ApplicationController
	before_action only: [:show, :edit, :update, :destroy]
	
  def index
    # Faz a autenticação e verifica se existe algum comand
  	if(self.auth_check(params[:auth_request_key]) && params.has_key?(:command))
      case params[:command]
      when "lis_tall"
        people = Person.all
        things = Thing.all
        places = Place.all

        response_array = {:message => "Todos os valores no banco: "}
        values_array = {:people => people.select(:id, :name),
                        :things => things.select(:id, :name),
                        :places => places.select(:id, :name)}
      when "get_random"
        people, places, things = find_rand_in_db
        enc_uri_string = params_encode(people.id, things.id, places.id)
        
        response_array = {:message => "Valores randomizados:"}
        values_array = {:people => people.name,
                        :idPeople => people.id,
                        :things => things.name,
                        :idThings => things.id,
                        :places => places.name,
                        :idPlaces => places.id,
                        :image => people.image.url(:medium),
                        :enc_uri => enc_uri_string}
      when "get_one_random_string"
        people, places, things = find_rand_in_db
        enc_uri_string = params_encode(people.id, things.id, places.id)

        response_array = {:message => "Valores randomizados em uma string: "}
        values_array = {:string => "#{people.name} #{things.name} at #{places.name}",
                        :image => "#{people.image.url(:medium)}",
                        :enc_uri => enc_uri_string}
      when "get_selected_values"
        if(params.has_key?(:idPeople) && 
          params.has_key?(:idPlaces) && 
          params.has_key?(:idThings) &&
          Person.exists?(params[:idPeople]) &&
          Place.exists?(params[:idPlaces]) &&
          Thing.exists?(params[:idThings]))
            people = Person.find(params[:idPeople])
            places = Place.find(params[:idPlaces])
            things = Thing.find(params[:idThings])
            enc_uri_string = params_encode(people.id, things.id, places.id)

            response_array = {:message => "Valores selecionados por id: "}
            values_array = {:string => "#{people.name} #{things.name} at #{places.name}",
                            :image => "#{people.image.url(:medium)}",
                            :enc_uri => enc_uri_string}
        else
          response_array = {:message => "Erro: parâmetros ou item no banco de dados não existente"}
        end
      else
        response_array = {:message => "Erro: comando desconhecido "}
      end
  	else
      response_array = {:message => "Erro: falha na autenticação."}
  	end

    #manda a resposta para o usuário
    response = {:response => response_array,
                :values => values_array}
    self.send_response(response)
  end
  
  def auth_check(auth_local)
  	auth_token = "62b15f01097ad285ca8162829afa86ae"
  	if(!auth_local.nil? && auth_local == auth_token)
   		return true
		else
   		return false
  	end
  end

  def send_response(response)
    respond_to do |format|
      format.json  { render :json => response }
    end
  end

  def find_rand_in_db
    offsetPerson = rand(Person.count)
    @people = Person.offset(offsetPerson).first

    offsetPlace = rand(Place.count)
    @places = Place.offset(offsetPlace).first

    offsetThing = rand(Thing.count)
    @things = Thing.offset(offsetThing).first

    return @people, @places, @things
  end

  def params_encode(idPeople, idThings ,idPlaces)
    return share_url = 'http://gotspoilergen.herokuapp.com/?enc_uri=xZ3' + idPeople.to_s + 'p3x' + idPlaces.to_s + 'm12' + idThings.to_s
  end
end