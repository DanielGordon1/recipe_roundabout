require 'rest-client'
require 'json'

class ChatGPTService
  CHATGPT_API_ENDPOINT = 'ENDPOINT'.freeze
  API_KEY = ENV['CHAT_GPT'].freeze

  def self.get_new_recipe_suggestions(favorite_recipes, ingredients)
    request_payload = {
      favorite_recipes: favorite_recipes,
      ingredients: ingredients
    }

    begin
      # Make a POST request to ChatGPT API
      response = RestClient.post(
        CHATGPT_API_ENDPOINT,
        request_payload.to_json,
        { 'Authorization': "Bearer #{API_KEY}", 'Content-Type': 'application/json' }
      )
      parsed_response = JSON.parse(response.body)
      
      parsed_response['new_recipe_suggestions']
    rescue RestClient::ExceptionWithResponse => e
      # Handle API request errors
      puts "Error: #{e.response}"
      nil
    end
  end
end
