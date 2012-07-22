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
    x >= 0 && x < COLS && y < LINES && y >= 0 && dungeon.get(target) != '#'
  end

  def potion?(target)
    dungeon.get(target) == POTION
  end

  def trap?(target)
    dungeon.get(target) == TRAP
  end

  def money?(target)
    dungeon.get(target) == MONEY
  end

  def monsters
    @monsters ||= world.entities.select {|e| e[:id] != :player }
  end

  def tick_monster(monster)
    dy = player.y - monster.y
    dx = player.x - monster.x
    my = dy == 0 ? 0 : dy / dy.abs
    mx = dx == 0 ? 0 : dx / dx.abs
    target = [monster.y + my, monster.x + mx]

    if can_move? target
      monster.move(target)
    else
      target = calc_target(monster, (rand 4))
      monster.move(target) if can_move? target
    end

    if monster.y == player.y && monster.x == player.x
      alert("GAME OVER")
      exit
    end
  end

  def tick_monsters
    monsters.each do |m| tick_monster(m) end
  end

  def calc_target(entity, key)
    case key
    when 0; target = [entity.y, entity.x - 1]
    when 1; target = [entity.y, entity.x + 1]
    when 2; target = [entity.y + 1, entity.x]
    when 3; target = [entity.y - 1, entity.x]
    else target = [entity.y, entity.x]
    end
  end

  def alert(s)
    win = Window.new 5, s.length + 6, LINES/2, COLS/2
    win.box ?|, ?-
    win.setpos 2, 3
    win.addstr s
    win.getch
  end

  def tick
    case @key = world.win.getch
    when ?h; target = [player.y, player.x - 1]
    when ?l; target = [player.y, player.x + 1]
    when ?j; target = [player.y + 1, player.x]
    when ?k; target = [player.y - 1, player.x]
    when ?y; target = [player.y - 1, player.x - 1]
    when ?u; target = [player.y - 1, player.x + 1]
    when ?b; target = [player.y + 1, player.x - 1]
    when ?n; target = [player.y + 1, player.x + 1]
    when ?q; exit
    end

    if can_move? target
      player.y = target[0]
      player.x = target[1]

      if money? target
        player.money += 1
        dungeon.clear(target)
      end

      if trap? target
        player.hp -= 1
        dungeon.clear(target)
      end

      if potion? target
        player.hp += 1
        dungeon.clear(target)
      end
    end

    tick_monsters

    if player.hp == 0
      puts "GAME OVER"
      world.win.getch
      exit
    end

    Drawing.draw(world, target.inspect)
  end
end
