60.times{|a|puts((0..240).map{|b|x=y=i=0;until(x*x+y*y>4||i==99);x,y,i=x*x-y*y+b/120.0-1.5,2*x*y+a/30.0-1,i+1;end;i==99?'#':'.'}*'');}
