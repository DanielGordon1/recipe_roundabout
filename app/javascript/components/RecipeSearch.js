import React, { useState } from 'react';
import RecipeCard from './RecipeCard';
import axios from 'axios';

const RecipeSearch = ({ recipes, currentUser }) => {
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
      setSearchResults(response.data);
    } catch (error) {
      setError('Error fetching recipes. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const toggleFavorite = (recipeId) => {
    setSearchResults((prevRecipes) =>
      prevRecipes.map((recipe) =>
        recipe.id === recipeId ? { ...recipe, isFavorited: !recipe.isFavorited } : recipe
      )
    );
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
      <div className="recipe-list">
        {searchResults.map((recipe) => (
          <RecipeCard
            key={recipe.id}
            recipe={recipe}
            isFavorited={recipe.isFavorited}
            toggleFavorite={() => toggleFavorite(recipe.id)}
            currentUser={currentUser}
          />
        ))}
      </div>
    </div>
  );
};

export default RecipeSearch;
