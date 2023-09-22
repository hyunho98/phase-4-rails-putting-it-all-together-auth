class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    before_action :authorize

    def index
        recipes = Recipe.all
        render json: recipes, include: :user
    end

    def create
        user = User.find(session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, include: :user, status: :created
    end


    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def authorize
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

    def record_invalid(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
