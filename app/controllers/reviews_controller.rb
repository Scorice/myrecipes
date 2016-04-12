class ReviewsController < ApplicationController
  before_action :require_user
  
  def new
    @review = Review.new
  end
  
  def create
    
  end
  
  private
  
    def review_params
      params.require(:review).permit(:title, :body, :rating)
    end
end