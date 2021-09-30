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

ANGLE_DICT = {
  n: 0,
  w: 90,
  s: 180,
  e: 270
}.freeze

SV_REDIRECT = { n: :n, s: :s, e: :e, w: :w }
SH_REDIRECT = { n: :n, s: :s, e: :e, w: :w }

SW_REDIRECT = { e: :s, n: :w }
SE_REDIRECT = { w: :s, n: :e }
NW_REDIRECT = { e: :n, s: :w }
NE_REDIRECT = { w: :n, s: :e }

NA_REDIRECT = { n: :x, s: :x, e: :x, w: :x }

TRACK_REDIRECT = {
  SV: SV_REDIRECT,
  SH: SH_REDIRECT,
  SW: SW_REDIRECT,
  SE: SE_REDIRECT,
  NW: NW_REDIRECT,
  NE: NE_REDIRECT,
  NA: NA_REDIRECT
}

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
    pos: { x: 0 * GRID_SIZE, y: 11 * GRID_SIZE },
    direction: :e
  )
  args.state.trains << args.state.blue_train
  args.state.red_train = Train.new(
    args,
    sprite: RED_TRAIN,
    pos: { x: 14 * GRID_SIZE, y: 2 * GRID_SIZE },
    direction: :w
  )
  args.state.trains << args.state.red_train
end

def z_draw(args, layers:, debug: nil)
  args.outputs.primitives << layers if layers
  args.outputs.debug << debug if debug
end

class Train
  attr_accessor :sprite

  def initialize(_args, sprite:, pos:, direction:)
    @pos_x = pos[:x]
    @pos_y = pos[:y]
    @direction = direction
    @angle = ANGLE_DICT[@direction]
    @speed = 1
    @sprite = sprite
  end

  def tick(args)

    grid_x = ((@pos_x) / GRID_SIZE).floor
    grid_y = ((@pos_y) / GRID_SIZE).floor

    map_tile = MAP[grid_y][grid_x]

    if args.state.tick_count.mod(GRID_SIZE).zero?
      @direction = TRACK_REDIRECT[map_tile][@direction]
      @angle = ANGLE_DICT[@direction]
    end

    case @direction
    when :n
      @pos_y += @speed
    when :w
      @pos_x -= @speed
    when :s
      @pos_y -= @speed
    when :e
      @pos_x += @speed
    when :x
      # do nothing
    end

    pos = { x: @pos_x, y: @pos_y }
    angle = { angle: @angle }

    @sprite = @sprite.merge(pos).merge(angle)
  end
end
