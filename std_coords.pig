c = LOAD 'coords.txt' using PigStorage('|') as (d1:float,m1:float,s1:float,c1:chararray,d2:float,m2:float,s2:float,c2:chararray);

ne1 = FILTER c BY (c1 matches 'N') and (c2 matches 'E');
nw1 = FILTER c BY (c1 matches 'N') and (c2 matches 'W');
se1 = FILTER c BY (c1 matches 'S') and (c2 matches 'E');
sw1 = FILTER c BY (c1 matches 'S') and (c2 matches 'W');

ne2 = FOREACH ne1 GENERATE d1+m1/60+s1/3600,      d2+m2/60+s2/3600;
nw2 = FOREACH nw1 GENERATE d1+m1/60+s1/3600,    -(d2+m2/60+s2/3600);
se2 = FOREACH se1 GENERATE -(d1+m1/60+s1/3600),   d2+m2/60+s2/3600;
sw2 = FOREACH sw1 GENERATE -(d1+m1/60+s1/3600), -(d2+m2/60+s2/3600);

nesw = UNION ne2,nw2,se2,sw2;
dump nesw;
