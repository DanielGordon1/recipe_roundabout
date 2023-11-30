import React from 'react';
import api from '../packs/axios';

const RecipeCard = ({ recipe, isFavorited, toggleFavorite, currentUser }) => {

  const handleFavorite = async () => {
    try {
      await api.post(`/recipes/${recipe.id}/favorite`);
      toggleFavorite();
    } catch (error) {
      alert('Whoopsie - something sent wrong 🥲')
    }
  };

  return (
    <div key={recipe.id} className="recipe-card">
      <h3>{recipe.title}</h3>
      {currentUser && 
        <button onClick={handleFavorite}>
          {isFavorited ? 'Unfavorite' : 'Favorite'}
        </button> 
      }
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
  );
};

export default RecipeCard;
