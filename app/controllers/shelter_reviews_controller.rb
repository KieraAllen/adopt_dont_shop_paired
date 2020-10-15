
class ShelterReviewsController < ApplicationController
  def new
    @shelter_id = params[:shelter_id]
  end

  def create
    user = User.find_by(name: params[:name])
    review = Review.new(shelter_review_params)

    if user
      review.user_id = user.id
      if review.save

        redirect_to "/shelters/#{params[:shelter_id]}"
      else
        flash[:notice] = "Please fill in the 'Title', 'Rating', and 'Content' fields"

        redirect_to "/shelters/#{params[:shelter_id]}/reviews/new"
      end
    else
      flash[:notice] = "User could not be found"
      redirect_to "/shelters/#{params[:shelter_id]}/reviews/new"
    end
  end

  def edit
    @shelter = Shelter.find(params[:shelter_id])
    @review = Review.find(params[:review_id])
    @user = User.find(@review.user_id)
  end

  def update
    review = Review.find(params[:review_id])
    User.find(review.user_id).update(name: params[:name])

    review.update(
      {
      title: params[:title],
      rating: params[:rating],
      content: params[:content],
      picture: params[:picture]
      })
    review.save
    redirect_to "/shelters/#{params[:shelter_id]}"
  end

  def destroy
    Review.destroy(params[:review_id])
    redirect_to "/shelters/#{params[:shelter_id]}"
  end

  private
  def shelter_review_params
    params.permit(:title, :rating, :picture, :content, :shelter_id)
  end
end
