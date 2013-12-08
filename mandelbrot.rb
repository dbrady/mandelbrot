# This is the highest-contrast, and I think, prettiest, version. It
# uses .'s and #'s. 136 chars.
# 60.times{|a|puts((0..240).map{|b|x=y=i=0;until(x*x+y*y>4||i==99);x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1;end;i==99?'#':'.'}*'');}


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
