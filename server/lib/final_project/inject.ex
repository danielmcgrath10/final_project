defmodule FinalProject.Inject do
  alias FinalProject.Photos

  def photo(name) do
    photos = Application.app_dir(:final_project, "priv/photos")
    path = Path.join(photos, name)
    {:ok, hash} = Photos.save_photo(name, path)
    hash
  end

end
