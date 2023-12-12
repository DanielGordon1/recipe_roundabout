# Need this workaround to make sure deploying to fly.io does not break due to it having no DB in the build process.
begin
  ActiveRecord::Base.connection
rescue ActiveRecord::ConnectionNotEstablished
else
  Flipper.enable_percentage_of_actors(:chat_gpt_recommendations, ENV['GPT_RECIPE_PERCENTAGE'])
end
