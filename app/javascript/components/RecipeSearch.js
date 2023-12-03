import React, { useState } from 'react';
import RecipeList from './RecipeList';
import api from '../packs/axios';

const RecipeSearch = ({ recipes, currentUser, favoriteRecipeIds }) => {
  const [query, setQuery] = useState('');
  const [searchResults, setSearchResults] = useState(recipes);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    try {
      const response = await api.get(`/recipes?query=${query}`);
      console.log(response)
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
      <RecipeList
        recipeList={searchResults}
        currentUser={currentUser}
        favoriteRecipeIds={favoriteRecipeIds}
      />
    </div>
  );
};

export default RecipeSearch;
