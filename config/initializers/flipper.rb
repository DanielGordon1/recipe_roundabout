# Initializers are loaded each time a rails command is fired.
# We need this workaround to make sure that whenever we run a rails/rake command the process does not break.
# F.E. when deploying to fly.io there is no DB in the build process.
Rails.application.config.after_initialize do
  # Only load this config when a server is started or when the rails console is started.
  if defined?(::Rails::Server) || defined?(::Rails::Console)
    Flipper.enable_percentage_of_actors(:chat_gpt_recommendations, ENV['GPT_RECIPE_PERCENTAGE'])
  end
end
