class CountiesController < ApplicationController
  def index

  end

  def search
    plate = county_params[:number_plate]
    county_code = detect_county_code(plate)

    county = search_county_code(county_code)

    if county
      p "DEBUG: county has been found ==== #{county}====="
    else
      p "DEBUG: ===== county not found ======= #{county}"
    end

    redirect_to :root
  end

  def search_county_code(county_code)
    # TODO
    # create a new page for the new search
    # test searching logic because numbers are stored as "001". turn them to integers first and compare them
    # try and add tests for the new feature
    codes.each do |code|
      code = code.split(" ")
      if code.first.to_i == county_code.to_i
        ## TODO: investigate whether ranges can be used here e.g code[2..-1]
        return code.slice(2, code.size).join(" ")
      end
    end

    false
  end

  private

  def county_params
    params.require(:county).permit(:number_plate)
  end

  def fetch_county_codes
    Rails.cache.fetch("county_codes", expires_in: 10.days) do
      File.read("lib/configs/county_codes.txt")
    end
  end

  def detect_county_code
    number_plate.scan(/\d+/).first
  end
end
