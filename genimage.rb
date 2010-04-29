#!/usr/bin/env ruby
require 'RMagick'

SIZE_X = 1920
SIZE_Y = 1080
MAX_ITERATIONS = 512

#min_x = -1.25
# right half
min_x = -0.375
# left half
# min_x = -1.5
min_y = -0.5
aspect = 0.5625 / 2.0

# Set x, calculate y
# right half
max_x = 0.25
# left half
# max_x = -0.625
xsize = max_x - min_x

ysize = xsize * aspect
max_y = min_y + ysize



SCALE_X = SIZE_X / xsize
SCALE_Y = SIZE_Y / ysize
  
canvas = Magick::Image.new(SIZE_X, SIZE_Y,
              Magick::HatchFill.new('white','lightcyan2'))
gc = Magick::Draw.new

k = MAX_ITERATIONS / 2

def palette_shift(x)
  x
end
palette = (0..MAX_ITERATIONS).map do |i|
  if i < 32
    # black -> green
    k = (256 * (i / 32.0)).floor
    "#%02x%02x%02x" % [0, k, 0]
  elsif i < 128
    # black -> blue
    k = (256 * ((i-32) / 96.0)).floor
    "#%02x%02x%02x" % [0, 0, 255]
  elsif i < 256
    # blue -> white
    k = (256 * ((i-128) / 128.0)).floor
    "#%02x%02x%02x" % [k, k, 255]
  else
    "#%02x%02x%02x" % [255, 255, 255]
  end
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
# right half
canvas.write('mandel_right.png')
# left half
# canvas.write('mandel_left.png')


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

