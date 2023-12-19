class RecipeSearchService
  LIMIT = ENV.fetch("LIMIT", 50)
  MIN_SCORE_RANK = ENV.fetch("MIN_SCORE_RANK", 0.1)

  # rubocop:disable Metrics/MethodLength
  def self.build_sql(query)
    # ~220ms

    sanitized_query = ActiveRecord::Base.connection.quote(query)
    sql = <<~SQL
      SELECT
        recipes.*,
        ts_rank(
          (
          recipes.title_searchable ||
          -- We use the 'simple' algo because we don't need language-specific features like stemming and stop words.
          setweight(to_tsvector('simple', coalesce(string_agg(ingredients.description, ' '), '')), 'B')
          -- to make this work we could/should add ingredients as a text column on the recipe model,
          -- that way we dont have to do an aggregation -->
        ),
        -- why use of simple here? and what does plainto_tsquery return/ create?
        plainto_tsquery('simple', #{sanitized_query})
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
        (
          recipes.title_searchable ||
          -- is this aggregation a performance hit? -->
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

  def self.basic_search(query)
    # ~ 600ms
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
    # ~ 120ms
    words = query.split
    first = words.shift
    sql = "recipes.title ILIKE '%#{first}%' OR ingredients.description ILIKE '%#{first}%' \n"
    words.each { |word| sql << "OR recipes.title ILIKE '%#{word}%' OR ingredients.description ILIKE '%#{word}%' \n" }

    Recipe.left_joins(:ingredients)
          .where(sql)
          .order("recipes.id ASC")
          .limit(LIMIT)
          .distinct
  end

  def self.search(query)
    sql = build_sql(query)
    # We create a subquery by wrapping the actual sql query in an select query.
    # This way we return an ActiveRecord Relation object so we can chain AR methods to the result.
    results = Recipe.includes(:ingredients).select('*').from("(#{sql}) AS recipes")

    results
  end

  def self.test_search(query)
    sql = build_sql(query)
    results = ActiveRecord::Base.connection.execute(sql)

    results
  end
end
