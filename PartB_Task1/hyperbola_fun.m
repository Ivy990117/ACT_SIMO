function z = hyperbola_fun(x,y,r1,r2,d)
    z =abs (sqrt((x-r1(1)).^2+(y-r1(2)).^2)-sqrt((x-r2(1)).^2+(y-r2(2)).^2))-d;
end