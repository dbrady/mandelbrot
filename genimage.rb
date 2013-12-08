#!/usr/bin/env ruby
require 'RMagick'

# TODO:
#
# - Scriptize this. Take cmdline args for resolution, xmin, xmax,
#   ymin, ymax (optional, calculate from aspect ratio if not present)
#
# - Make a LERP palette. Set anchor colors and build the palette by
#   lerping between them.
#
# - Map/reduce this.
#
#   - Instead of rendering to an image, render to datafile.
#
#   - Read a set of datafiles and render them to image.
#
#   - Have the main script distribute/fork n processes to render
#     datafiles for different sections of the image; these are later
#     stitched together by the renderer.

SIZE_X = 192*4
SIZE_Y = 108*4
MAX_ITERATIONS = 512

RIGHT_HALF = 1
LEFT_HALF = 2

half = RIGHT_HALF
# half = LEFT_HALF

min_x, min_y, max_x = if half == RIGHT_HALF
                        [-0.3125, -0.75, 0.0]
                      else
                        [-0.625, -0.75, -0.3125]
                      end

min_y = -0.75
aspect = SIZE_Y.to_f / SIZE_X

xsize = max_x - min_x
ysize = xsize * aspect
max_y = min_y + ysize

# ----------------------------------------------------------------------
# Resize a rectangle down to a given sector.
# Given a division count n and two indexes x and y, divide the rectangle
# into n*n "sectors", and return the sector rectangle at (x,y). x and y
# are in the range 0..n-1.
def sector(n,x,y,l,t,r,b)
  dx = (r-l)/n
  dy = (b-t)/n
  l2 = l + dx*x
  t2 = t + dy*y
  r2 = l2 + dx
  b2 = t2 + dy
  puts "sector(%d,%d,%d): (%f, %f, %f, %f) -> (%f, %f, %f, %f)" % [n,x,y,l,t,r,b,l2,t2,r2,b2]
  [l2, t2, r2, b2]
end

# ----------------------------------------------------------------------
# Translate a rectangle by a given number of sectors.
def scootch(n,x,y,l,t,r,b)
  dx = (r-l)/n
  dy = (b-t)/n
  l2 = l + dx*x
  t2 = t + dy*y
  r2 = r + dx*x
  b2 = b + dy*y
  puts "scootch(%d,%d,%d): (%f, %f, %f, %f) -> (%f, %f, %f, %f)" % [n,x,y,l,t,r,b,l2,t2,r2,b2]
  [l2, t2, r2, b2]
end

min_x, min_y, max_x, max_y = sector(8, 7, 0, min_x, min_y, max_x, max_y)
min_x, min_y, max_x, max_y = sector(8, 4, 4, min_x, min_y, max_x, max_y)
min_x, min_y, max_x, max_y = sector(4, 3, 0, min_x, min_y, max_x, max_y)

# min_x, min_y, max_x, max_y = scootch(6, 0, -1, min_x, min_y, max_x, max_y)
# min_x, min_y, max_x, max_y = sector(4, 1, 1, min_x, min_y, max_x, max_y)

min_x, min_y, max_x, max_y = scootch(1, -1, 0, min_x, min_y, max_x, max_y)

# recalc xsize, ysize
xsize = max_x - min_x
ysize = max_y - min_y


#min_x += 7*((max_x-min_x)/8)
#max_y -= 7*((max_y-min_y)/8)

# min_x += 7*((max_x-min_x)/8)
# min_y += 7*((max_y-min_y)/8)

SCALE_X = SIZE_X / xsize
SCALE_Y = SIZE_Y / ysize

canvas = Magick::Image.new(SIZE_X, SIZE_Y,
              Magick::HatchFill.new('white','lightcyan2'))
gc = Magick::Draw.new

k = MAX_ITERATIONS / 2

# ----------------------------------------------------------------------
# lerp
# given (x0, y0), (x1, y1):
# y = y0 + (x-x0) * ((y1-y0)/(x1-x0))
def lerp(x0, y0, x1, y1, x)
  (y0 + (x-x0) * ((y1-y0).to_f/(x1-x0))).round
end

# ----------------------------------------------------------------------
class Color
  attr_accessor :red, :green, :blue
  def initialize(red, green, blue)
    @red, @green, @blue = red, green, blue
  end
  def to_s
    "#%02x%02x%02x" % [@red, @green, @blue]
  end
end

controls = [
  [  0, Color.new(  0,  0,  0)],
  [128, Color.new(  0, 92,  0)],
  [256, Color.new(255,255,  0)],
  [512, Color.new(255,255,  0)],
]

palette = (0..MAX_ITERATIONS).map do |i|
  k=0
  k+=1 while controls[k][0] < i
  j=k-1
  a,b=controls[j],controls[k]

  c = Color.new(
            lerp(a[0],a[1].red,b[0],b[1].red,i),
            lerp(a[0],a[1].green,b[0],b[1].green,i),
            lerp(a[0],a[1].blue,b[0],b[1].blue,i)
            ).to_s

  puts "%3d [%2d,%2d] (%3d-%3d): %s" % [i, j, k, controls[j][0], controls[k][0], c]

  c
end

palette[-1] = "#000000"

histogram = Hash.new(0)
tick = SIZE_X/2
(0..SIZE_Y).each do |py|
  puts "Row #{py}/#{SIZE_Y}..."
  (0..SIZE_X).each do |px|
    cx, cy = (px / SCALE_X)+min_x, (py / SCALE_Y)+min_y
    # x,y,i=x*x-y*y+b/150.0-1.5,2*x*y+a/40.0-1,i+1
    i,x,y=0,cx,cy
    while x*x+y*y < 4 && i < MAX_ITERATIONS
      i+=1
      x,y = x*x-y*y+cx, 2*x*y+cy
    end
    puts "    #{i}" if px==tick
    gc.fill(palette[i])
    histogram[i] += 1
    gc.point(px,py)
  end
end

gc.draw(canvas)
filename = if half == RIGHT_HALF
             'mandel_right.png'
           else
             'mandel_left.png'
           end
puts "writing #{filename}..."
canvas.write(filename)
puts "done."

class Array
  def sum
    self.inject {|a,b| a+b} || 0
  end
end

digits = (Math::log(SIZE_X*SIZE_Y)/Math::log(10)).ceil
fmt = "%5d: %#{digits}d (> %#{digits}d) (< %#{digits}d)"
max = histogram[MAX_ITERATIONS]
puts '-' * 80
p histogram[MAX_ITERATIONS]
puts '-' * 80

(0..(MAX_ITERATIONS / 4)).each do |i|
  puts (0..3).map {|j|
    n = i+(j*MAX_ITERATIONS/4)
    fmt % [n, histogram[n], (n+1..MAX_ITERATIONS).map {|k,v| histogram[k]}.sum-max, (0..n-1).map {|k,v| histogram[k]}.sum]
  } * '    '
end
