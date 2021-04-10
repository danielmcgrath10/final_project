defmodule FinalProjectWeb.Router do
  use FinalProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FinalProjectWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", FinalProjectWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    get "/users/photo/:id", UserController, :profile_photo
    resources "/session", SessionController, only: [:create]
    resources "/posts", PostController, except: [:new, :edit]
    resources "/likes", LikeController, except: [:new, :edit]
    resources "/comments", CommentController, except: [:new, :edit]
    resources "/reviews", ReviewController, except: [:new, :edit]
    resources "/votes", VoteController, except: [:new, :edit]
    resources "/revcomment", RevCommentController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FinalProjectWeb.Telemetry
    end
  end
end
