class FlowersController < ApplicationController
  def index
    @flowers = Flower.all
  end

  def create
    @flower = Flower.new(
      color: random_color,
      number_of_petals: rand(10..50)
    )

    if @flower.save
      if Flower.count == 20
        # Select a random number between 6 and 10 flowers to remove
        number_to_remove = rand(6..10)
        flowers_to_remove = Flower.order("RAND()").limit(number_to_remove)
        removed_count = flowers_to_remove.destroy_all.length
        flash[:notice] = "Garden got too crowded! #{removed_count} flowers were removed to make space 🌸"
      else
        flash[:notice] = "New flower sprouted! 🌸"
      end
      redirect_to root_path
    else
      redirect_to root_path, alert: "Failed to create flower"
    end
  end

  private

  def random_color
    %w[Red Blue Yellow Pink Purple Orange White Violet].sample
  end
end 