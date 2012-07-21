require 'curses'

LINES = 20
COLS  = 80

include Curses
init_screen
curs_set 0
noecho

module Drawing
  extend self
  def draw_entity(win, entity)
    win.setpos entity.y + 1, entity.x + 1
    win.addstr entity.char
    win.refresh
  end

  def draw_status(world, info=nil)
    player = world.player
    win    = world.win
    win.setpos 0, 2
    win.addstr "x: #{player.x} y: #{player.y} $: #{player.money} hp: #{player.hp} #{info} ---"
  end

  def draw_dungeon(win, dungeon)
    win.setpos 1, 0
    dungeon.lines.each do |line| win.addstr "|" + line + "|" end
    win.refresh
  end

  def draw(world, info=nil)
    draw_dungeon(world.win, world.dungeon)
    world.entities.each do |entity| draw_entity(world.win, entity) end
    draw_status(world, info)
  end
end
