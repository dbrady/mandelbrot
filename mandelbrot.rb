60.times{|a|
  240.times{|b|
    d,c,x,y=a/30.0-1,b/120.0-1.5,0,0;
    i=m=999;
    until(x*x+y*y>4||i==0);
      x,y,i=x*x-y*y+c,2*x*y+d,i-1;
    end;
    print(i==0 ?'#':'.');
  };
  puts;
}


# 240.times{|b|xyz(); print(i==0 ?'#':'.');}puts;
# puts (0..240).map{|b|xyz()==0?'#':'.')*''}
