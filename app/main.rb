# Teeny Tiny Trains
# By Dee Schaedler
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use , copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# Thee above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ----
# Game Constants
GRID_SIZE = 48 # 15x15 grid

# ----
# Sprite Constants
SPRITE_BASE = { w: GRID_SIZE, h: GRID_SIZE, source_w: 32, source_h: 32,
                path: 'sprites/sprites.png' }.freeze

RED_TRAIN = { source_x: 0, source_y: 0 }.merge(SPRITE_BASE)
BLUE_TRAIN = { source_x: 64, source_y: 32 }.merge(SPRITE_BASE)

RED_CAR = { source_x: 64, source_y: 0 }.merge(SPRITE_BASE)
BLUE_CAR = { source_x: 32, source_y: 0 }.merge(SPRITE_BASE)

TRACK_LIBRARY = {
  NA: nil,
  SV: { source_x: 0, source_y: 64, w: GRID_SIZE, h: GRID_SIZE, source_w: 32,
        source_h: 32, path: 'sprites/sprites.png' },
  SH: { source_x: 0, source_y: 64, angle: 90, w: GRID_SIZE, h: GRID_SIZE,
        source_w: 32, source_h: 32, path: 'sprites/sprites.png' },
  CT: { source_x: 32, source_y: 64, w: GRID_SIZE, h: GRID_SIZE, source_w: 32,
        source_h: 32, path: 'sprites/sprites.png' },
  NE: { source_x: 64, source_y: 64, w: GRID_SIZE, h: GRID_SIZE, source_w: 32,
        source_h: 32, path: 'sprites/sprites.png' },
  NW: { source_x: 64, source_y: 64, angle: 90, w: GRID_SIZE, h: GRID_SIZE,
        source_w: 32, source_h: 32, path: 'sprites/sprites.png' },
  SW: { source_x: 64, source_y: 64, angle: 180, w: GRID_SIZE, h: GRID_SIZE,
        source_w: 32, source_h: 32, path: 'sprites/sprites.png' },
  SE: { source_x: 64, source_y: 64, angle: 270, w: GRID_SIZE, h: GRID_SIZE,
        source_w: 32, source_h: 32, path: 'sprites/sprites.png' },
  BG: { source_x: 0, source_y: 0, angle: 90, w: GRID_SIZE, h: GRID_SIZE, source_w: 32,
        source_h: 32, path: 'sprites/blue_goal.png'},
  RG: { source_x: 0, source_y: 0, angle: 90, w: GRID_SIZE, h: GRID_SIZE, source_w: 32,
        source_h: 32, path: 'sprites/red_goal.png'}
}.freeze

# ----
# Map x: 0-25, y: 0-14

MAP = [
  %i[SH SH SH SH SW NA NA NA NA NA NA NA NA NA NA SE SH SH SH SE SH SE SH SH SH SH],
  %i[NA NA NA NA NE SH SH SH SH SH SH SH SH SH SH SW NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA NA NA NA NA NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA NA NA NA SE SH SH SH SH SE NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA NA NA NA SV NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA NE SH SH NW SH SH NE SH SH SH SH NE SH SH SH NE SH NW NA NA NA NA],
  %i[NA NA NA NA SV NA NA SV NA NA SV NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA SV NA NA SV NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA SV NA NA SV NA NA NA NA NE SH SH SH SW SH SW NA NA NA NA],
  %i[NA NA NA NA SV NA NA SV NA NA SV NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA NE SH SH NW NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SV NA NA SV NA NA SV NA NA NA NA SV NA NA NA SV NA SV NA NA NA NA],
  %i[NA NA NA NA SE SH SH NW SH SH NE SH SH SH SH NW SH SH SH NE SH NW NA NA NA NA],
  %i[NA NA NA NA SV NA NA NA NA NA NA NA NA NA NA SV NA NA NA NA NA NA NA NA NA NA],
  %i[SH RG SH SH NW NA NA NA NA NA NA NA NA NA NA NE SH SH SH SH SH SH SH SH BG SH]
].reverse.freeze

ANGLE_DICT = {
  n: 0,
  w: 90,
  s: 180,
  e: 270,
  x: 0,
  bf: 270,
  rf: 90
}.freeze

SV_REDIRECT = { n: :n, s: :s, e: :e, w: :w }.freeze
SH_REDIRECT = { n: :n, s: :s, e: :e, w: :w }.freeze

SW_REDIRECT = { e: :s, n: :w }.freeze
SE_REDIRECT = { w: :s, n: :e }.freeze
NW_REDIRECT = { e: :n, s: :w }.freeze
NE_REDIRECT = { w: :n, s: :e }.freeze

NA_REDIRECT = { n: :x, s: :x, e: :x, w: :x, x: :x }.freeze

BG_REDIRECT = { n: :bf, s: :bf, e: :bf, w: :bf, f: :bf }.freeze
RG_REDIRECT = { n: :rf, s: :rf, e: :rf, w: :rf, f: :rf }.freeze

TRACK_REDIRECT = {
  SV: SV_REDIRECT,
  SH: SH_REDIRECT,
  SW: SW_REDIRECT,
  SE: SE_REDIRECT,
  NW: NW_REDIRECT,
  NE: NE_REDIRECT,
  NA: NA_REDIRECT,
  BG: BG_REDIRECT,
  RG: RG_REDIRECT
}.freeze

$gtk.reset

def tick(args)
  args.state.init ||= false
  initialize(args) unless args.state.init

  mouse_click(args) if args.inputs.mouse.up

  z_layer = Array.new(3) { [] }

  z_layer[0] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h,
                  path: :background, primitive_marker: :sprite}

  z_layer[1] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h,
                  path: :straight_tracks, primitive_marker: :sprite }
  z_layer[1] << { x: 0, y: 0, w: args.grid.w, h: args.grid.h,
                  path: :corner_tracks, primitive_marker: :sprite }

  args.state.blue_train.each do |train|
    train.tick(args, :blue) unless args.state.blue_goal
    z_layer[2] << train.sprite
  end

  args.state.red_train.each do |train|
    train.tick(args, :red) unless args.state.red_goal
    z_layer[2] << train.sprite
  end

  debug = [args.gtk.framerate_diagnostics_primitives]

  z_draw(args, layers: z_layer, debug: debug)
end

def mouse_click(args)
  click_x = args.inputs.mouse.point[0]
  click_y = args.inputs.mouse.point[1]

  grid_x = (click_x / GRID_SIZE).floor
  grid_y = (click_y / GRID_SIZE).floor

  return unless click_x <= MAP[0].length * GRID_SIZE

  map_tile = args.state.map[grid_y][grid_x]
  case map_tile
  when :SW
    args.state.map[grid_y][grid_x] = :NW
  when :SE
    args.state.map[grid_y][grid_x] = :SW
  when :NW
    args.state.map[grid_y][grid_x] = :NE
  when :NE
    args.state.map[grid_y][grid_x] = :SE
  end

  args.clear_render_targets
  build_render_targets(args)
end

def initialize(args)
  args.state.init = true
  puts "Running Init at #{args.state.tick_count}"

  args.state.map ||= {}

  MAP.each_with_index do |row, index_y|
    args.state.map[index_y] ||= {}
    row.each_with_index do |spot, index_x|
      args.state.map[index_y][index_x] = spot
      args.render_target(:background).sprites << {x: index_x * GRID_SIZE, y: index_y * GRID_SIZE, w: GRID_SIZE, h: GRID_SIZE, path: 'sprites/gravel.png'}
    end
  end

  build_render_targets(args)

  args.state.blue_train = []
  args.state.blue_train << Train.new(
    args,
    sprite: BLUE_TRAIN,
    pos: { x: 3 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :e
  )

  args.state.blue_train << Train.new(
    args,
    sprite: BLUE_CAR,
    pos: { x: 2 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :e
  )

  args.state.blue_train << Train.new(
    args,
    sprite: BLUE_CAR,
    pos: { x: 1 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :e
  )

  args.state.blue_train << Train.new(
    args,
    sprite: BLUE_CAR,
    pos: { x: 0 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :e
  )

  args.state.red_train = []
  args.state.red_train << Train.new(
    args,
    sprite: RED_TRAIN,
    pos: { x: 22 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :w
  )

  args.state.red_train << Train.new(
    args,
    sprite: RED_CAR,
    pos: { x: 23 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :w
  )

  args.state.red_train << Train.new(
    args,
    sprite: RED_CAR,
    pos: { x: 24 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :w
  )

  args.state.red_train << Train.new(
    args,
    sprite: RED_CAR,
    pos: { x: 25 * GRID_SIZE, y: 14 * GRID_SIZE },
    direction: :w
  )

  args.state.blue_goal = false
  args.state.red_goal = false

  args.state.crash = false
end

def build_render_targets(args)
  args.state.map.each_pair do |index_y, row|
    row.each_pair do |index_x, spot|
      new_track = { x: index_x * GRID_SIZE, y: (index_y * GRID_SIZE) }
      if %i[SV SH].include? spot
        args.render_target(:straight_tracks).sprites << new_track.merge(TRACK_LIBRARY[spot])
      elsif spot != :NA
        args.render_target(:corner_tracks).sprites << new_track.merge(TRACK_LIBRARY[spot])
      end
    end
  end
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

  def tick(args, color)

    return unless @direction != :x

    if args.state.tick_count.mod(GRID_SIZE).zero?
      grid_x = (@pos_x / GRID_SIZE).floor
      grid_y = (@pos_y / GRID_SIZE).floor

      map_tile = args.state.map[grid_y][grid_x]

      if @pos_x < args.grid.left || @pos_x + GRID_SIZE > args.grid.right || @pos_y < args.grid.bottom || @pos_y + GRID_SIZE > args.grid.top
        @direction = :x
      elsif args.state.crash == true
        @direction = :x
      else
        @direction = TRACK_REDIRECT[map_tile][@direction]
        @angle = ANGLE_DICT[@direction]
        @sprite = @sprite.merge(angle: @angle)
      end

      case color
      when :blue
        args.state.red_train.each do |car|
          args.state.crash = true if args.geometry.intersect_rect? [@pos_x, @pos_y, GRID_SIZE, GRID_SIZE], car.sprite
        end
      when :red
        args.state.blue_train.each do |car|
          args.state.crash = true if args.geometry.intersect_rect? [@pos_x, @pos_y, GRID_SIZE, GRID_SIZE], car.sprite
        end
      end

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
    when :bf
      args.state.blue_goal = true
    when :rf
      args.state.red_goal = true
    when :x
      args.state.crash = true
    end

    @sprite = @sprite.merge(x: @pos_x, y: @pos_y)
  end
end
