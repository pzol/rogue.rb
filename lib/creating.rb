module Creating
  extend self

  World   = Struct.new(:dungeon, :entities, :win)
  Entity  = Struct.new(:id, :x, :y, :char, :hp, :money)
  Dungeon = Struct.new(:lines)

  module WorldEx
    def player
      @player ||= entities.detect {|e| e[:id] == :player }
    end
  end

  module DungeonEx
    def cell(target)
      return SPACE unless target
      y, x = target
      lines[y][x]
    end

    def put_cell(target, chr)
      y, x = target
      lines[y][x] = chr
    end
  end

  def dungeon_cell(y, x)
    r = rand 100
    case when r > 85; WALL
         when r == 1; MONEY
         when r == 2; POTION
         when r > 3 && r < 10; TRAP
         else SPACE
    end
  end

  def empty_dungeon
    lines = (1..LINES).map do |y|
      (1..COLS).map {|x| dungeon_cell(y, x) }.join
    end
    Dungeon.new(lines).extend(DungeonEx)
  end

  def monsters
    y, x = rand(COLS) + 1, rand(LINES) + 1
    [Entity.new(:monster, y, x, MONSTER, 1, 0)]
  end

  def entities
    @player  = Entity.new(:player, 10, 10, PLAYER, 10, 0)
    [@player, monsters].flatten
  end

  def new_world
    win = Window.new LINES + 2, COLS + 2 , 1, 0
    win.box ?|, ?-
    World.new(empty_dungeon, entities, win).extend(WorldEx)
  end
end
