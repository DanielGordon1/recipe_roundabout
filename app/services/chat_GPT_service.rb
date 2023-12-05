require 'rest-client'
require 'json'

# WIP
class ChatGptService
  CHATGPT_API_ENDPOINT = 'ENDPOINT'.freeze
  API_KEY = ENV['CHAT_GPT'].freeze

  def self.get_new_recipe_suggestions(recipe_titles:, ingredients:)
    request_payload = {
      favorite_recipes: favorite_recipes,
      ingredients: ingredients
    }
    begin
      response = RestClient.post(
        CHATGPT_API_ENDPOINT,
        request_payload.to_json,
        { 'Authorization': "Bearer #{API_KEY}", 'Content-Type': 'application/json' }
      )
      parsed_response = JSON.parse(response.body)
      parsed_response['new_recipe_suggestions'].map { |recipe_json| Recipe.new(title: recipe_json['title'], ) }
    rescue RestClient::ExceptionWithResponse => e
      # Handle API request errors
      puts "Error: #{e.response}"
      nil
    end
  end
end
