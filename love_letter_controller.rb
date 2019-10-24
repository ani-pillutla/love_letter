# myapp.rb
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/json'
require 'sinatra/cross_origin'
require 'uuid'
require_relative './game_classes/LoveLetter.rb'
require_relative './game_classes/Player.rb'
require_relative './game_classes/GameMaster.rb'

set :bind, '0.0.0.0'
set :port, 5000
configure do
  enable :cross_origin
end
before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

arr = []
uuid = UUID.new
game = LoveLetter.new
gm = GameMaster.new(game)
players = []

count = 0

get '/' do
  if (cookies[:session] == nil) 
    thisKey = uuid.generate
    cookies[:session] = thisKey
    player = Player.new(thisKey)
    players.push(player)
  end
  if (players.length == 2)
    redirect '/game_start'
  end
end

get '/game_start' do
  for player in players
    gm.add(player)
  "#{gm.get_players}"

post '/player_action' do
  request.body.rewind
  player_action = JSON.parse request.body.read
  json player_action
end

=begin
get '/hand' do
  if (cookies[:session] != nil)
    if (!player_hands.has_key?(cookies[:session]))
      size = 4
      hand = []
      while size > 0
        card = rand(8)
        hand << deck[card]
        size = size - 1
      end
      player_hands[cookies[:session]] = hand
    end
  end
    "#{player_hands[cookies[:session]]}"
end
=end

get '/deck' do
  #"#{love_letter.deck}"
end

get '/hand' do
  #json player1.hand
end

get '/remove_card' do
  if (cookies[:session] != nil)
    if (player_hands.has_key?(cookies[:session]))
      hand = player_hands[cookies[:session]]
      hand.pop
      player_hands[cookies[:session]] = hand
    end
  end
  redirect '/hand'
end

get '/draw' do
  #player1.draw(love_letter.get_card)
  #player2.draw(love_letter.get_card)
  redirect '/hand'
end



=begin
get '/draw' do
  if (cookies[:session] != nil)
    if (player_hands.has_key?(cookies[:session]))
      hand = player_hands[cookies[:session]]
      hand.push(cards[rand(8)])
      player_hands[cookies[:session]] = hand
    end
  end
  redirect '/hand'
end
=end

get '/play_guard' do
  #player_action = player1.play_guard('Player2','Priest') 
  #"#{love_letter.guard(player_action)}"
  redirect '/hand'
end

get '/play_priest' do
  #player_action = player1.play_priest('Player2')
  #"#{love_letter.priest(player_action)}"
end

get '/play_baron' do
  #player_action = player1.play_baron('Player2')
  #"#{love_letter.baron(player_action)}"
end

get '/peak' do
  display = "Player &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Hands<br>"
  player_hands.each do |key, value|
    value = value.map { |i| "'" + i.to_s + "'" }.join(",")
    display += "#{key} #{value}<br>"
  end 
  "#{display}"
end

  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
