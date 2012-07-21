class Game
  attr_reader :world, :dungeon, :player
  def initialize(world)
    @world   = world
    @dungeon = world.dungeon
    @player  = world.player
  end

  def play
    Drawing.draw(world)
    loop do
      tick
    end
  end

  def can_move?(target)
    return false unless target
    y, x = target
    x >= 0 && x < COLS && y < LINES && y >= 0 && dungeon.cell(target) != '#'
  end

  def potion?(target)
    dungeon.cell(target) == POTION
  end

  def trap?(target)
    dungeon.cell(target) == TRAP
  end

  def money?(target)
    dungeon.cell(target) == MONEY
  end

  def tick
    case @key = world.win.getch
    when ?h; target = [player.y, player.x - 1] #player.x -= 1 if player.x > 0
    when ?l; target = [player.y, player.x + 1] # player.x += 1 if player.x < (COLS  - 1)
    when ?j; target = [player.y + 1, player.x] #player.y += 1 if player.y < (LINES - 1)
    when ?k; target = [player.y - 1, player.x] #player.y -= 1 if player.y > 0
    when ?q; exit
    end

    if can_move? target
      player.y = target[0]
      player.x = target[1]

      if money? target
        player.money += 1
        dungeon.put_cell(target, SPACE)
      end

      if trap? target
        player.hp -= 1
        dungeon.put_cell(target, SPACE)
      end

      if potion? target
        player.hp += 1
        dungeon.put_cell(target, SPACE)
      end
    end

    if player.hp == 0
      puts "GAME OVER"
      world.win.getch
      exit
    end

    Drawing.draw(world, target.inspect)
  end
end
