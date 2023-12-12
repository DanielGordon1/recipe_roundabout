# Need this workaround to make sure deploying to fly does not break because it has no DB during the build process.
begin
  ActiveRecord::Base.connection
rescue ActiveRecord::ConnectionNotEstablished
else
  Flipper.enable_percentage_of_actors(:chat_gpt_recommendations, ENV['GPT_RECIPE_PERCENTAGE'])
end
