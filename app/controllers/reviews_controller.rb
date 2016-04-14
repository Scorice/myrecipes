class ReviewsController < ApplicationController
  before_action :set_review, only: [:update, :destroy]
  before_action :require_user
  before_action :require_same_or_admin_user, only: [:update, :destroy]
  
  def new
   @recipe = Recipe.find(params[:recipe_id]) 
   @review = @recipe.reviews.new
  end
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.build(review_params)
    @review.chef = current_user
    if @review.save
      flash[:success] = "Your review was updated successfully"
      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Sorry, there was an error saving your review"
      render 'new'
    end
  end
  
  def edit
    @review = Review.find(params[:id])
  end
  
  def update
    if @review.update(review_params)
      flash[:success] = "Your review was updated successfully"
      redirect_to recipe_path(@review.recipe)
    else
      render :edit
    end
  end
  
  def destroy
    @review.destroy
    flash[:success] = "Review Deleted"
    redirect_to recipe_path(params[:recipe_id])
  end
  
  private
  
    def review_params
      params.require(:review).permit(:body)
    end
    
    def set_review
      @review = Review.find(params[:id])
    end
    
    def require_same_or_admin_user
      if current_user != @review.chef && !current_user.admin?
        flash[:danger] = "You can only upate/delete comments if you created the comment or are an administrator"
      end
    end
end