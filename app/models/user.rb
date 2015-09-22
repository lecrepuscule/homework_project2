class User < ActiveRecord::Base
  
  has_many :intakes
  has_many :dishes, through: :intakes

  def current_intake
    nutrient_intakes = Hash.new(0)
    dishes.each do |dish|
      nutrient_intakes = dish.dish_nutrients.inject(nutrient_intakes) do |intakes, nutrient|
        intakes[nutrient.nutrient.name] += nutrient.daily_percentage
        intakes
      end
    end
    nutrient_intakes
  end

  def find_dish
    intakes = current_intake
    search_string = intakes.min_by(2) {|k,v| v}.to_h.keys.join(" ").gsub(/\((.*?)\)/, "")
    recommendations = HTTParty.get("https://api.edamam.com/search?q=#{search_string}&app_id=#{ENV['edamam_app_id']}&app_key=#{ENV['edamam_key']}")
    binding.pry
  end


end
