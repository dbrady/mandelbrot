= Mandelbrot

This code was just scratch lying around, so it's not particularly
well-documented. Sorry about that. Or well-refactored. Sorry about
that too. You'll need RMagick to make it work. REALLY sorry about
that. Don't forget to compile in .png support.

It was mostly an experiment in ruby fiddling, so the code is not fast
by any means. It takes several hours to do a good 1080p render. This
could be accomplished in a few seconds in C, but that wasn't the point
when I wrote this. The point was to do it in Ruby, and that has been
achieved. :-)

== Installation

Good luck.

=== Ubuntu 13.10

I *think* all you really need is imagemagick and libmagickwand-dev,
but I installed libmagick-dev as well, not sure if it's needed.

    # minimal install -- you may also need libmagick-dev
    sudo apt-get install imagemagick libmagickwand-dev
    gem install rmagick

== Running It
Just run

  ruby genimage.rb

Okay, this code was a brutal hack and I didn't really care about
cleaning it up once it was done. I wanted Mandelbrot images, not the
code to generate it. :-)

So... I noodled around inside the Mandelbrot function space, and found
an area that I think looks quite attractive spread across two
monitors, each 1920x1080. genimage with no modifications will emit
mandel_right.png, which is the right half of the part of the fractal
that I really liked. On lines 29/30 if you change which half is
defined it will move the viewport over and emit the left half of the
image. Conveniently, since I was trying to emit 2 images for 2
monitors, if you change the half to LEFT_HALF, the image file emitted
will be named mandel_left.png.

== What's this about halves?

Oh yeah. So I originally intended this to generate fractal images for
my desktop at work. I had two monitors, so I needed two images,
ideally rendering adjacent areas of the mandelbrot plane.

== Making a single 3960x1080 image

Since RMagick requires imagemagick, you'll have the `convert` tool at
your command-line. You can stitch the two images together with

    convert mandel_left.png mandel_right.png +append mandel_big.png

== Files
=== genimage.rb

Is the generator. All the parameters are hard-coded,
sorry. There are some trivial image manipulation functions in there,
mostly to adjust the viewport by scootching around the mandelbrot
plane looking for interesting sections, and also to colorize the
output on an interesting scale.

I wrote this about a year ago, so your guess is as good as mine when
it comes to digging around in there to figure out what does what. If
you document or refactor anything, please send me a pull request and
I'll merge it in.

=== mandelbrot.rb

This is just a scratch file where I tried to generate an ascii-art mandelbrot
fractal that would fit in a single tweet. There are several versions
in there, all under 140 characters, that I have commented on. Special
thanks to [@brahbur](http://twitter.com/brahbur) on Twitter for
helping me find the shortest possible optimization (so far).
