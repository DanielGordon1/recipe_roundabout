import React, { useState } from 'react';
import axios from 'axios';

const RecipeSearch = () => {
  const [query, setQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = async (e) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    try {
      const response = await axios.get(`/recipes?query=${query}`);
      setSearchResults(response.data);
    } catch (error) {
      setError('Error fetching recipes. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div>
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

      <div>
        <h2>Search Results:</h2>
        <ul>
          {searchResults.map((recipe) => (
            <li key={recipe.id}>
              <h3>{recipe.title}</h3>
              <p>Cooking Time: {recipe.cook_time}</p>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default RecipeSearch;
