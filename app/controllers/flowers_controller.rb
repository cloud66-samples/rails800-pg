class FlowersController < ApplicationController
  def index
    @cache_status = false  # Default to false
    @flowers = Rails.cache.fetch("flowers_list", expires_in: 1.minute) do
      @cache_status = true  # Set to true when we're querying the DB
      Flower.all.to_a
    end
  end

  def show
    @flower = Flower.find(params[:id])
  end

  def create
    @flower = Flower.new(
      color: random_color,
      number_of_petals: rand(3..20)
    )

    if @flower.save
      if Flower.count >= 20
        number_to_remove = rand(6..10)
        flowers_to_remove = Flower.order("RAND()").limit(number_to_remove)
        removed_count = flowers_to_remove.destroy_all.length
        Rails.cache.delete("flowers_list")
        flash[:notice] = "Garden got too crowded! #{removed_count} flowers were removed to make space 🌸"
      else
        Rails.cache.delete("flowers_list")
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