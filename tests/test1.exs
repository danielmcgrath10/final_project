defmodule TestOne do
  def try_me do
    options = [params: [
      location: 42.3364553,-71.0349193,
      radius: 50,
      type: "restaurant",
      key: "AIzaSyDbjo2l0isKuzvgy9-kygM25p3jLjgL3nk"
    ]]
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

    HTTPoison.request(
      :get,
      url,
      "",
      [{"Accept", "application/json"}],
      options
    )
  end
end

TestOne.say_hello
