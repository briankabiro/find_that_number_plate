class HomeController < ApplicationController
  def index
  end

  def search
    query = number_plate_params[:number_plate]
    code = detect_country_code(query)
    country = search_code(code)

    if country
      flash[:success] = "Yaay. #{query} is the diplomatic number for #{country}."
      redirect_to :root
    else
      flash[:warning] = "Ooops. It seems that diplomatic number does not exist"
      redirect_to :root
    end
  end

  def search_code(country_code)
    # use a hash table. array is not efficient
    codes.each do |code|
      code = code.split(" ")
      if code.first == country_code
        return code.third
      end
    end

    return
  end

  private

  def number_plate_params
    params.require(:home).permit(:number_plate)
  end

  def codes
    @codes ||= fetch_codes
  end

  def fetch_codes
    Rails.cache.fetch("diplomatic_codes", expires_in: 1.hour) do
      File.read("lib/configs/diplomatic_codes.txt").split("\n").select { |x| x.present? }
    end
  end

  def detect_country_code(number_plate)
    if number_plate.upcase.include? "CD"
      ## accomodate people who don't use a space when entering the number plate
      number_plate.split.first
    end
  end
end
