$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'symbols'
require 'drawing'
require 'creating'
require 'game'

include Symbols

game = Game.new(Creating.new_world)
game.play
