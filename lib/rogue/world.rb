module World
  extend self

  class World < Struct.new(:dungeon, :entities, :win)

    def player
      @player ||= entities.detect {|e| e[:id] == :player }
    end
  end

  class Entity < Struct.new(:id, :x, :y, :char, :hp, :money)
    def move(target)
      self.y, self.x = target
    end
  end

  class Dungeon < Struct.new(:lines)
    def clear(target)
      put(target, SPACE)
    end

    def get(target)
      return SPACE unless target
      y, x = target
      lines[y][x]
    end

    def put(target, chr)
      y, x = target
      lines[y][x] = chr
    end
  end

  def create
    win = Window.new LINES + 2, COLS + 2 , 1, 0
    win.box ?#, ?#
    World.new(empty_dungeon, entities, win)
  end

  def dungeon_cell
    r = rand 1000
    case when r > 540; WALL
         when r == 1; MONEY
         when r == 2; POTION
         when r > 0 && r < 20; TRAP
         else SPACE
    end
  end

  # calculate tile for smoothing
  def tile(y, x, matrix)
    matrix[y - 1 .. y + 1].map {|line| line[x - 1 .. x + 1]}
  end

  # should the tile be a wall?
  def wall?(tile)
    tile.flatten.count {|t| t == WALL} > 4
  end

  def random_line(cols=COLS)
    (1..cols).map {|x| dungeon_cell }
  end

  def smooth(lines)
    lines.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        if wall? tile(y, x, lines)
          lines[y][x] = WALL
        else
          lines[y][x] = cell == WALL ? SPACE : cell
        end
      end
    end
  end

  def empty_dungeon(lines=LINES, cols=COLS)
    random_lines = (1..lines).map do
      random_line(cols)
    end
    Dungeon.new(smooth(random_lines))
  end

  def random_monster
    y, x = rand(COLS) + 1, rand(LINES) + 1
    Entity.new(:monster, y, x, MONSTER, 1, 0)
  end

  def monsters
    ms = (1..5).map { |e| random_monster  }
  end

  def entities
    player  = Entity.new(:player, 10, 10, PLAYER, 10, 0)
    [player, monsters].flatten
  end

end
