defmodule TestOne do
  def try_me do
    lat = 42.3364553
    lon = -71.0349193
    radius = 50
    type = "restaurant"
    key = "AIzaSyDbjo2l0isKuzvgy9-kygM25p3jLjgL3nk"
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lon}&radius=#{radius}&type=#{type}&key=#{key}"
    IO.inspect url

    HTTPoison.get!(url)
  end
end

TestOne.try_me
