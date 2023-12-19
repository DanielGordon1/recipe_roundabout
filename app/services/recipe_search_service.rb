class RecipeSearchService
  LIMIT = ENV.fetch("LIMIT", 50)
  MIN_SCORE_RANK = ENV.fetch("MIN_SCORE_RANK", 0.1)

  def self.build_sql(query)
    sanitized_query = ActiveRecord::Base.connection.quote(query)
    sql = <<-SQL
      SELECT
        recipes.*,
        ts_rank(
          (
          recipes.title_searchable ||
          setweight(to_tsvector('simple', coalesce(string_agg(ingredients.description, ' '), '')), 'B')
        ),
        plainto_tsquery('simple', #{sanitized_query})
        ) AS rank
      FROM
        recipes
      LEFT JOIN
        ingredients ON ingredients.recipe_id = recipes.id
      GROUP BY
        recipes.id
      HAVING
      ts_rank(
        (
          recipes.title_searchable ||
          setweight(to_tsvector('simple', coalesce(string_agg(ingredients.description, ' '), '')), 'B')
        ),
        plainto_tsquery('simple', #{sanitized_query})
      ) > #{MIN_SCORE_RANK}
      ORDER BY
        rank DESC,
        recipes.title ILIKE #{sanitized_query} DESC,
        recipes.id ASC
      LIMIT #{LIMIT}
    SQL
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
