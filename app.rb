require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  erb :index
end

get '/meetups' do
  authenticate!
  @meetups = Meetup.all.order(:name)
  #@creator = MeetupCreator.find_by

  erb :'meetups/index'
end


get '/create' do
authenticate!
  erb :create
end


post '/create' do

new_meetup = Meetup.create(name: params[:name], description: params[:description],
location: params[:location], meetup_creator_id: session[:user_id].to_i)

flash[:notice] = "You have created a meetup!"

redirect '/meetups'

end




get '/meetups/:id' do
  authenticate!
  @meetup = Meetup.find(params[:id])
  @is_member = MeetupMember.find_by(user_id: current_user.id, meetup_id: params[:id])

erb :'/meetups/show'
end

post '/meetups/:meetup_id/comment' do
  @comments = Comment.create(title: params[:title], body: params[:body],
    meetup_id: params[:meetup_id], user_id: current_user.id)

  redirect '/meetups'
end

post '/meetups/:meetup_id/leave' do

  user = MeetupMember.find_by(user_id: current_user.id, meetup_id: params[:meetup_id])
#binding.pry
  user.destroy
  flash[:notice] = "You have left the Group!"

  redirect '/meetups/params[:meetup_id]'
end

post '/meetups/:id' do

meetup_member = MeetupMember.create(user_id: current_user.id, meetup_id: params[:id])
flash[:notice] = "You have joined this meetup!"

redirect '/meetups'
end







get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end


get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
