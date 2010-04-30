60.times{|a|p (0..240).map{|b|x=y=i=0;(x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1)until(x*x+y*y>4||i>98);i>98?0:1}*''}
