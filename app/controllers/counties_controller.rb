class CountiesController < ApplicationController
  def search_county_code(county_code)
    # TODO
    # create a new page for the new search
    # test searching logic because numbers are stored as "001". turn them to integers first and compare them
    # try and add tests for the new feature
  end

  private

  def county_code
    Rails.cache.fetch("county_codes", expires_in: 10.days) do
      File.read("lib/configs/county_codes.txt")
    end
  endend
