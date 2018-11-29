# This is the highest-contrast, and I think, prettiest, version. It
# uses .'s and #'s. 136 chars.
# 60.times{|a|puts((0..240).map{|b|x=y=i=0;until(x*x+y*y>4||i==99);x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1;end;i==99?'#':'.'}*'');}

# Slightly expanded to handle whatever is going on with your monitor
require 'io/console'
height, width = $stdin.winsize.map {|i| i-2}
height.times do |a|
  puts(
    (0..width).map do |b|
      x=y=i=0
      # x*x+y*y>4 is a stripped-down "is the absolute value of this complex number >= 2.0?"
      until(x*x+y*y>4||i==99)
        # x,y are the components of c
        # Mandelbrot: f(z[n+1]) = z[n]**2 + c, where f() does not diverge
        # Where c = x + yi, and z[0] == 0
        # And "f() does not diverge" basically means
        # "The absolute value of z[n] stays under V for at least N iterations",
        # where V and N are arbitrarily selected. In this script, V=2 and N=99.
        #
        # One bit of math I keep forgetting: A complex number has a real
        # component and an imaginary component. If we treat x as the real part
        # and y as the imaginary part, and we square c, we end up with c.x**2 -
        # c.y**2 + 2*c.x*c.y*i. Here's the part I keep forgetting: STOP. Do not
        # try to solve for y or x directly. A complex number has a real part and
        # an imaginary part. x**2 - y**2 is the real part, and 2*x*y*i is the
        # imaginary part. You're done. Stop solving the equation, Dave!
        #
        # Optimization notes:
        # - we avoid the cost of a square root by testing z[n]**2 < V**2
        # - if f(z[n]) diverges at any point before n==99, we stop immediately.
        #   Noodling this out on paper shows that squaring a number > 1.0 will
        #   diverge continually, so if the x or y component grow large enough to
        #   make the abs > some value, it can never again converge below 1.0.
        # - Also, for drawing the pretty mandelbrot heatmap scale thingies, you
        #   need to know the exact number of iterations before f() crossed your
        #   arbitrary threshold, so you might as well stop computing.
        # - We don't represent i anywhere for what I hope are obvious
        #   reasons. It's enough to know that the new real component = new_x =
        #   x**2-y**2 and the new imaginary component = new_y = 2*x*y.

        # Once we have all that under our belt, all we need is to choose a
        # region of the mandelbrot set, and scale it to the computer
        # screen. This arithmetic quickly obscures all the "real" math of the
        # mandelbrot fractal. I should probably do a proper rectangle scale
        # here, but since this originated in a "fit in a single tweet" program,
        # I opted to simply bash in a mangification factor to scale up to, and
        # since we're trying to zoom IN on a small region, this means dividing,
        # not multiplying, by the screen scale. That explodes everything outward
        # from the origin, which is at the top left of the screen, but we want
        # the origin in the center of the screen, so next we need to translate
        # by half the scale. Since we've already scaled the function to the
        # screen, we can just offset in function space rather than worrying
        # about how many lines or columns are on the display.

        # So, all that said...

        # a is the current line (y) rendered on screen, e.g. (0..height)
        # b is the current column (x) rendered on screen, e.g. (0..width)
        #
        # The mandelbrot function for x, y is:
        #
        # new_x = x*x-y*y+b / screen_scale_x - fn_offset_x
        # new_y = 2*x*y+a / screen_scale_y - fn_offset_y
        # new_i = i + 1
        #
        # i is needed because if we go a set number of iterations (e.g. 99)
        #     without diverging (e.g. |z[n]| never exceeds 2.0), the original
        #     x,y are considered to be "in" the Mandelbrot set. If you want to
        #     make a "pretty" picture of mandelbrot here, you render each i in a
        #     different color on a scale. Everything inside the set is a fixed
        #     color, but the closer to the boundary the more iterations you need
        #     before you diverge. Set each one to a different color and presto,
        #     you get a pretty picture.
        x,y,i = x*x-y*y+b/(width/2.0)-1.5, 2*x*y+a/(height/2.0)-1, i+1
      end
      # if i==99, we're inside the set so render a "#"
      # otherwise, we've diverged so render a "."
      i==99 ? '#' : '.'
    end.join('')
  )
end


# Special thanks to @brahbur http://twitter.com/brahbur for this
# much-shortened version. By emitting 0's and 1's directly, instead of
# translating to .'s and #'s, the image is still visible but you save
# about 14 characters of "rendering" code. 122 chars.
# 60.times{|a|p (0..240).map{|b|x=y=i=0;(x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1)until(x*x+y*y>4||i>98);i>98?0:1}*''}

# Realization that i>98?0:1 is identical to 99<=>i as long as i can
# never reach 100. 118 chars.
# 60.times{|a|p (0..240).map{|b|x=y=i=0;x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1 until x*x+y*y>4||i>98;99<=>i}*''}


# try using Fixnum#step instead of Fixnum#times. Saves exactly 0
# characters, but I liked learning a different way to iterate. 118
# chars.
# -3.step(3,0.1){|a|p -3.step(2,0.02).map{|b|x=y=i=0;x,y,i=x*x-y*y+b/2,2*x*y+a/3,i+1 until x*x+y*y>4||i>98;99<=>i}*''}


# This is HUUUGE and insanely cool-looking. You'll need to scale your
# font down to where it's basically 1 antialiased pixel per
# character--you need a viewport 2001 characters across. As a result
# this appears to "render" an actual image rather than just text. 126
# chars.
# -1.0.step(1.0,0.004){|a|p -1.5.step(0.5,0.001).map{|b|x=y=i=0;x,y,i=x*x-y*y+b,2*x*y+a,i+1 until x*x+y*y>4||i>98;99<=>i}*'' }
