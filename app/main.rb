# Teeny Tiny Trains
# Copyright 2021 Dee Schaedler
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# Thee above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ----
# Game Constants
GRID_SIZE = 48 # 15x15 grid

# ----
# Sprite Constants
SPRITE_BASE = { w: GRID_SIZE, h: GRID_SIZE, source_w: 32, source_h: 32,
                path: 'sprites/sprites.png' }.freeze

RED_TRAIN = { source_x: 0, source_y: 0 }.merge(SPRITE_BASE)
BLUE_TRAIN = { source_x: 64, source_y: 32 }.merge(SPRITE_BASE)

RED_CAR = { source_x: 0, source_y: 64 }.merge(SPRITE_BASE)
BLUE_CAR = { source_x: 0, source_y: 32 }.merge(SPRITE_BASE)

TRACK_LIBRARY = {}

# No Track
TRACK_LIBRARY[:NA] = nil

# Straight Track
TRACK_LIBRARY[:SV] = { source_x: 0, source_y: 64 }.merge(SPRITE_BASE)
TRACK_LIBRARY[:SH] = { angle: 90 }.merge(TRACK_LIBRARY[:SV])

# Cross Track
TRACK_LIBRARY[:CT] = { source_x: 32, source_y: 64 }.merge(SPRITE_BASE)

# Turning Track
TRACK_LIBRARY[:NE] = { source_x: 64, source_y: 64 }.merge(SPRITE_BASE)
TRACK_LIBRARY[:NW] = { angle: 90 }.merge(TRACK_LIBRARY[:NE])
TRACK_LIBRARY[:SW] = { angle: 180 }.merge(TRACK_LIBRARY[:NE])
TRACK_LIBRARY[:SE] = { angle: 270 }.merge(TRACK_LIBRARY[:NE])

# Up
TRACK_LIBRARY[:US] = { source_x: 0, source_y: 32 }.merge(SPRITE_BASE)
TRACK_LIBRARY[:UT] = { source_x: 32, source_y: 32 }.merge(SPRITE_BASE)

# Right
TRACK_LIBRARY[:RS] = { angle: 90 }.merge(TRACK_LIBRARY[:US])
TRACK_LIBRARY[:RT] = { angle: 90 }.merge(TRACK_LIBRARY[:UT])

# Down
TRACK_LIBRARY[:DS] = { angle: 180 }.merge(TRACK_LIBRARY[:US])
TRACK_LIBRARY[:DT] = { angle: 180 }.merge(TRACK_LIBRARY[:UT])

# Left
TRACK_LIBRARY[:LS] = { angle: 270 }.merge(TRACK_LIBRARY[:US])
TRACK_LIBRARY[:LT] = { angle: 270 }.merge(TRACK_LIBRARY[:UT])

# Switch Mirrors
TRACK_LIBRARY[:UD] = { flip_horizontal: true }.merge(TRACK_LIBRARY[:US])
TRACK_LIBRARY[:UY] = { flip_horizontal: true }.merge(TRACK_LIBRARY[:UT])

TRACK_LIBRARY[:RD] = { flip_vertical: true }.merge(TRACK_LIBRARY[:RS])
TRACK_LIBRARY[:RY] = { flip_vertical: true }.merge(TRACK_LIBRARY[:RT])

TRACK_LIBRARY[:DD] = { flip_horizontal: true }.merge(TRACK_LIBRARY[:DS])
TRACK_LIBRARY[:DY] = { flip_horizontal: true }.merge(TRACK_LIBRARY[:DT])

TRACK_LIBRARY[:LS] = { flip_vertical: true }.merge(TRACK_LIBRARY[:LS])
TRACK_LIBRARY[:LT] = { flip_vertical: true }.merge(TRACK_LIBRARY[:LT])

# ----
# Map

MAP = [
  %i[NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[SH SW NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[NA SV NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[SE NW NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[SV NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[SV NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[SV NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA SE SW NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA SV SV NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA SV SV NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA NA NE SH SH SH SH],
  %i[NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA],
  %i[NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA]
].reverse.freeze

def tick(args)
  args.state.init ||= false
  initialize(args) unless args.state.init

  z_layer = Array.new(3) { [] }

  z_layer[0] << args.state.tracks

  args.state.trains.each do |train|
    train.tick(args)
    z_layer[1] << train.sprite
  end

  z_draw(args, layers: z_layer)
end

class Train
  attr_accessor :sprite

  def initialize(_args, sprite:, pos:, angle: )

    @pos_x = pos[:x]
    @pos_y = pos[:y]
    @angle = angle
    @speed = 0
    @max_speed = 2.5
    @acceleration = 0.01
    @sprite = sprite
  end

  def tick(_args)
    @speed += @acceleration if @speed < @max_speed

    grid_x = ((@pos_x + (GRID_SIZE / 2)) / GRID_SIZE).floor
    grid_y = ((@pos_y + (GRID_SIZE / 2)) / GRID_SIZE).floor

    map_tile = MAP[grid_y][grid_x]

    case map_tile
    when :SV
      case @angle
      when 0
        @pos_y += @speed
      when 180
        @pos_y -= @speed
      when -135
        @angle = 180
      when -45
        @angle = 0
      when 135
        @angle = 180
      when 45
        @angle = 0
      end

    when :SH
      case @angle
      when -90
        @pos_x += @speed
      when 90
        @pos_x -= @speed
      when -135
        @angle = -90
      when 135
        @angle = 90
      when -45
        @angle = -90
      end
    # off_y = @pos_y % GRID_SIZE
    # if off_y != 0
    #   @pos_y -= off_y
    # end
    when :SW
      case @angle
      when -90
        @angle = -135
      when 0
        @angle = 45
      when -135
        @pos_x += @speed * 0.707
        @pos_y -= @speed * 0.707
      when 45
        @pos_x -= @speed * 0.707
        @pos_y += @speed * 0.707
      end
    when :SE
      case @angle
      when 90
        @angle = 135
      when 0
        @angle = -45
      when 45
        @angle = 135
      when 135
        @pos_x -= @speed * 0.707
        @pos_y -= @speed * 0.707
      when -45
        @pos_x += @speed * 0.707
        @pos_y += @speed * 0.707
      end
    when :NE
      case @angle
      when 90
        @angle = 45
      when 180
        @angle = -135
      when -135
        @pos_x += @speed * 0.707
        @pos_y -= @speed * 0.707
      when 45
        @pos_x -= @speed * 0.707
        @pos_y += @speed * 0.707
      end
    when :NW
      case @angle
      when -90
        @angle = -45
      when 180
        @angle = 135
      when 135
        @pos_x -= @speed * 0.707
        @pos_y -= @speed * 0.707
      when -45
        @pos_x += @speed * 0.707
        @pos_y += @speed * 0.707
      end
    end

    pos = { x: @pos_x, y: @pos_y }
    angle = {angle: @angle}

    @sprite = @sprite.merge(pos).merge(angle)
  end
end

def initialize(args)
  args.state.init = true
  puts "Running Init at #{args.state.tick_count}"

  args.state.tracks = []
  MAP.each_with_index do |row, index_y|
    row.each_with_index do |spot, index_x|
      new_track = { x: index_x * GRID_SIZE, y: (index_y * GRID_SIZE) }
      args.state.tracks << new_track.merge(TRACK_LIBRARY[spot]) if spot != :NA
    end
  end

  args.state.trains = []
  args.state.blue_train = Train.new(
    args,
    sprite: BLUE_TRAIN,
    pos: {x: 0 * GRID_SIZE, y: 11 * GRID_SIZE},
    angle: -90
  )
  args.state.trains << args.state.blue_train
  args.state.red_train = Train.new(
    args,
    sprite: RED_TRAIN,
    pos: {x: 14 * GRID_SIZE, y: 2 * GRID_SIZE},
    angle: 90
  )
  args.state.trains << args.state.red_train

end

def z_draw(args, layers:, debug: nil)
  args.outputs.primitives << layers if layers
  args.outputs.debug << debug if debug
end
