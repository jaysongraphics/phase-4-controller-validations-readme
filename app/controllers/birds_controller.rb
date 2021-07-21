class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  validates :name, presence: true, uniqueness: true

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    if bird.valid?
      render json: bird, status: :created
    else
      render json: { errors: bird.errors }, status: :unprocessable_entity
      #422 Unprocessable Entity response status code indicates that the server understands the content type of the request entity, and the syntax of the request entity is correct, but it was unable to process the contained instructions
      #another way
#       bird = Bird.create!(bird_params)
#       render json: bird, status: :created
#        rescue ActiveRecord::RecordInvalid => invalid
#        render json: { errors: invalid.record.errors
       # status: :unprocessable_entity
    end
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update(bird_params)
    render json: bird
  end
  #ANOTHER WAY
  # def update
  #   bird = find_bird
  #   bird.update!(bird_params)
  #   render json: bird
  #    rescue ActiveRecord::RecordInvalid => invalid
  #   render json: { errors: invalid.record.errors },
   # status: :unprocessable_entity
  # end 

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

end
