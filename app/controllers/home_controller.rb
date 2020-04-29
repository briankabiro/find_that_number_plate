class HomeController < ApplicationController
  def index
  end

  def search
    query = number_plate_params[:number_plate]
    code = detect_country_code(query)
    country = search_code(code)

    if country
      flash[:success] = "#{query.upcase} is the diplomatic number for #{country}."
      redirect_to :root
    else
      flash[:warning] = "Ooops. It seems that #{query.upcase} is not a valid diplomatic number"
      redirect_to :root
    end
  end

  def search_code(country_code)
    ## TODO: use a hash? array is not efficient for searching
    codes.each do |code|
      code = code.split(" ")
      if code.first == country_code
        ## TODO: investigate whether ranges can be used here e.g code[2..-1]
        return code.slice(2, code.size).join(" ")
      end
    end

    return
  end

  private

  def number_plate_params
    params.require(:home).permit(:number_plate)
  end

  def codes
    ## is this performant? check whether this improves time
    @codes ||= fetch_codes
  end

  def fetch_codes
    Rails.cache.fetch("diplomatic_codes", expires_in: 10.days) do
      File.read("lib/configs/diplomatic_codes.txt").split("\n").select { |x| x.present? }
    end
  end

  def detect_country_code(number_plate)
    number_plate.scan(/\d+/).first
  end
end
