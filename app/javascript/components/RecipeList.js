import React, { useState, useEffect } from 'react';
import RecipeCard from './RecipeCard';
import api from '../packs/axios';

const RecipeList = ({ recipeList, currentUser, favoriteRecipeIds, shouldFilter=false }) => {
  const [recipes, setRecipes] = useState(recipeList);
  console.log(recipeList, currentUser, favoriteRecipeIds, shouldFilter)
  const toggleFavorite = async (recipeId) => {
    try {
      const response = await api.post(`/recipes/${recipeId}/favorite`);
      if (!response.data.favorited && shouldFilter) {
        setRecipes((prevRecipes) =>
          prevRecipes.filter((recipe) => recipe.id !== recipeId)
        );
      } else {
        setRecipes((prevRecipes) =>
          prevRecipes.map((recipe) =>
            recipe.id === recipeId ? { ...recipe, is_favorited: response.data.favorited } : recipe
          )
        );
      }
    } catch (error) {
      console.error('Error toggling favorite:', error);
    }
  };

  useEffect(() => {
    setRecipes((prevRecipes) =>
      prevRecipes.map((recipe) => ({
        ...recipe,
        is_favorited: favoriteRecipeIds.includes(recipe.id),
      }))
    );
  }, [favoriteRecipeIds]);

  useEffect(() => {
    setRecipes(recipeList);
  }, [recipeList]);

  return (
    <div className="recipe-list">
      {recipes.map((recipe) => (
        <RecipeCard
          key={recipe.id}
          recipe={recipe}
          isFavorited={recipe.is_favorited}
          toggleFavorite={() => toggleFavorite(recipe.id)}
          currentUser={currentUser}
        />
      ))}
    </div>
  );
};

export default RecipeList;
