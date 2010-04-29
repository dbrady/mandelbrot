

60.times{|a|puts((0..240).map{|b|x=y=i=0;until(x*x+y*y>4||i==99);x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1;end;i==99?'#':'.'}*'');}


60.times{|a|p (0..240).map{|b|x=y=i=0;x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1 until x*x+y*y>4||i>98;99<=>i}*''}
                 
60.times{|a|p (0..240).map{|b|x=y=i=0;x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1 until x*x+y*y>4||i>98;99<=>i}*''}

# try using step instead of times with a divisor
-3.step(3,0.1){|a|p -3.step(2,0.02).map{|b|x=y=i=0;x,y,i=x*x-y*y+b/2,2*x*y+a/3,i+1 until x*x+y*y>4||i>98;99<=>i}*''}
                 

# This is HUUUGE and insanely cool-looking.
# -1.0.step(1.0,0.004){|a|p -1.5.step(0.5,0.001).map{|b|x=y=i=0;x,y,i=x*x-y*y+b,2*x*y+a,i+1 until x*x+y*y>4||i>98;99<=>i}*''}
