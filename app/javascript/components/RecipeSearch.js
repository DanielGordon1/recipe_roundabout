import React, { useState } from 'react';
import axios from 'axios';

const RecipeSearch = ({ recipes }) => {
  const [query, setQuery] = useState('');
  const [searchResults, setSearchResults] = useState(recipes);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    try {
      const response = await axios.get(`/recipes?query=${query}`, {
        headers: {
          'Accept': 'application/json'
        }
      });
      console.log(response.data)
      setSearchResults(response.data);
    } catch (error) {
      setError('Error fetching recipes. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="recipe-search">
      <form onSubmit={handleSearch}>
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search recipes..."
        />
        <button type="submit">Search</button>
      </form>

      {isLoading && <p>Loading...</p>}
      {error && <p>{error}</p>}
      <h2>Filtered Recipes:</h2>
      <br/>
      <div className="recipe-list">
      
      {searchResults.map((recipe) => (
        <div key={recipe.id} className="recipe-card">
          <h3>{recipe.title}</h3>
          <div className="recipe-info">
            <p>Cooking Time: {recipe.cooking_time_minutes}</p>
            <p>Prep Time: {recipe.preparation_time_minutes}</p>
            <p>Rating: {recipe.rating}</p>
            <p>Cuisine: {recipe.cuisine}</p>
            <img src={recipe.image_url} alt={recipe.title} className="recipe-image" />
          </div>
          <div className="ingredients">
            <h4>Ingredients:</h4>
            <ul>
              {recipe.ingredients.map((ingredient) => (
                <li key={ingredient.id}>{ingredient.description}</li>
              ))}
            </ul>
          </div>
        </div>
      ))}
    </div>
    </div>
  );
};

export default RecipeSearch;
