class RecipeSearchService
  LIMIT = ENV.fetch("LIMIT", 50)
  MIN_SCORE_RANK = ENV.fetch("MIN_SCORE_RANK", 0.1)

  # rubocop:disable Metrics/MethodLength
  def self.build_sql(query)
    # ~220ms - meh

    sanitized_query = ActiveRecord::Base.connection.quote(query)
    sql = <<~SQL
      SELECT
        recipes.*,
        ts_rank(
          -- D, C, B , A --
          ARRAY[0.1, 0.2, 0.8, 1.0],
          (
            -- see db/migrate/20231219152218_add_text_search_column_to_recipes_and_ingredients.rb
            recipes.title_searchable ||
            -- We use the 'simple' algo because we don't need language-specific features like stemming and stop words.
            setweight(to_tsvector('simple', coalesce(string_agg(ingredients.description, ' '), '')), 'B')
            -- ingredients.description_searchable does not work.
            -- Its an aggregation and can only be aggregated within this context.
            -- to make this work we could/should add ingredients as a text column on the recipe model,
            -- that way we dont have to do an aggregation -->
          ),
          plainto_tsquery('simple', #{sanitized_query})
          -- We can add a normalization parameter here that adjusts rank for document length.
        ) AS rank
      FROM
        recipes
      -- We use an inner join to only display recipes that have ingredients attached
      INNER JOIN
        ingredients ON ingredients.recipe_id = recipes.id
      GROUP BY
        recipes.id
      HAVING
      ts_rank(
        ARRAY[0.1, 0.2, 0.8, 1.0],
        (
          recipes.title_searchable ||
          -- Is this aggregation a performance hit? Need to research -->
          setweight(to_tsvector('simple', coalesce(string_agg(ingredients.description, ' '), '')), 'B')
        ),
        plainto_tsquery('simple', #{sanitized_query})
      ) > #{MIN_SCORE_RANK}
      ORDER BY
        rank DESC,
        recipes.title ILIKE #{sanitized_query} DESC
      LIMIT #{LIMIT}
    SQL
  end
  # rubocop:enable Metrics/MethodLength

  def self.search(query)
    sql = build_sql(query)
    # We create a subquery by wrapping the actual sql query in an select query.
    # This way we return an ActiveRecord Relation object so we can chain AR methods to the result.
    results = Recipe.includes(:ingredients).select('*').from("(#{sql}) AS recipes")

    results
  end

  def self.basic_search(query)
    # ~ 600ms - lol
    sql = <<~SQL
      recipes.title @@ :query OR
      ingredients.description @@ :query
    SQL
    Recipe.joins(:ingredients)
          .where(sql, query: query)
          .order(Arel.sql("recipes.title ILIKE '#{query}' DESC,
                           ingredients.description ILIKE '#{query}' DESC,
                           recipes.id ASC"))
          .limit(LIMIT)
  end

  def self.super_basic_search(query)
    # ~ 120ms - quite fast
    words = query.split
    first = words.shift
    # This is bad, because SQL injection. I know ^_^.
    sql = "recipes.title ILIKE '%#{first}%' OR ingredients.description ILIKE '%#{first}%' \n"
    words.each { |word| sql << "OR recipes.title ILIKE '%#{word}%' OR ingredients.description ILIKE '%#{word}%' \n" }

    Recipe.left_joins(:ingredients)
          .where(sql)
          .order("recipes.id ASC")
          .limit(LIMIT)
          .distinct
  end

  def self.test_search(query)
    sql = build_sql(query)
    results = ActiveRecord::Base.connection.execute(sql)

    results
  end
end
