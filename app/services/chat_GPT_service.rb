require 'rest-client'
require 'json'

class ChatGptService
  CHATGPT_API_ENDPOINT = 'https://api.openai.com/v1/completions'.freeze
  API_KEY = ENV['CHAT_GPT'].freeze
  MODEL = "gpt-3.5-turbo-instruct".freeze
  TEMPERATURE = 0
  MAX_TOKENS = 5

  def initialize(recipe_titles:, ingredients:)
    @recipe_titles = recipe_titles
    @ingredients = ingredients
  end

  def new_recipe_suggestions
    response = call_completions_api
    parsed_response = JSON.parse(response.body)
    return
    # WIP
    parsed_response['new_recipe_suggestions'].map { |recipe_json| Recipe.new(title: recipe_json['title']) }
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.debug { "Error: #{e.response}" }
    nil
  end

  private

  def call_completions_api
    RestClient.post(
      CHATGPT_API_ENDPOINT,
      request_payload.to_json,
      { Authorization: "Bearer #{API_KEY}", 'Content-Type': 'application/json' }
    )
  end

  def request_payload
    {
      model: "gpt-3.5-turbo-instruct",
      prompt: "Can you supply me with a recommendation for a recipe based on the following recipe names:
               #{@recipe_titles.join(', ')}, and the following ingredients: #{@ingredients.join(', ')}?",
      temperature: TEMPERATURE,
      max_tokens: MAX_TOKENS
    }
  end
end
