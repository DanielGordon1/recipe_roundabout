# Initializers are loaded each time a rails command is fired.
# We need this workaround to make sure that whenever we run a rails/rake command the process does not break.
# F.E. when deploying to fly.io there is no DB in the build process.
# Also when running rails db:create we first load the initializers, then the command is executed.
begin
  ActiveRecord::Base.connection
rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::NoDatabaseError
else
  Flipper.enable_percentage_of_actors(:chat_gpt_recommendations, ENV['GPT_RECIPE_PERCENTAGE'])
end
