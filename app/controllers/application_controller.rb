class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  configure do
    enable :sessions
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    haml :index
  end
end
