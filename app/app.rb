ENV['RACK_ENV'] ||= 'development'

require_relative 'data_mapper_setup'
require 'sinatra/base'
require 'sinatra/flash'


class FakersBnB < Sinatra::Base

  register Sinatra::Flash
  use Rack::MethodOverride
  enable :sessions
  set :session_secret, 'super_secret'

  get '/' do
    redirect '/properties'
  end

  # =========== LISTINGS =========== #

  get '/properties' do
    @listings = Listing.all
    erb :'properties/index'
  end

  get '/properties/new' do
    erb :'properties/new'
  end

  post '/properties' do
      Listing.create(title:     params[:title],
                     location:  params[:location],
                     price:     params[:price],
                     imageurl:  params[:imageurl],
                     user:      current_user)
      redirect '/properties'
    end

    # =========== USERS =========== #

  get '/users/new' do
      @user = User.new
      erb :'users/new'
  end

  post '/users' do
    @user = User.create(username:              params[:username],
                        first_name:            params[:first_name],
                        surname:               params[:surname],
                        email:                 params[:email],
                        password:              params[:password],
                        password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/properties')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

# =========== SESSIONS =========== #

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/properties')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.keep[:notice] = 'You have been logged out'
    redirect to '/properties'
  end

  # ============================== #

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

end
