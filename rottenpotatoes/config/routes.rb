Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  # Route that posts 'Search TMDb' form
  post '/movies/search_tmdb'
end
