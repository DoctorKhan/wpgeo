A = LOAD 'n1pn2s.tsv' AS (n2sub:chararray);
B = LOAD 'wp_coords.tsv' AS (titles:chararray, coords:chararray);

J = JOIN B BY titles, A BY n2sub USING 'replicated';
J2 = FOREACH J GENERATE coords;

S = FOREACH J2 GENERATE FLATTEN(STRSPLIT($0, '\\|'));
S2 = FILTER S BY NOT($0 MATCHES '^missing');

ne8 = FILTER S2 BY ($3 matches 'N') and ($7 matches 'E');
nw8 = FILTER S2 BY ($3 matches 'N') and ($7 matches 'W');
se8 = FILTER S2 BY ($3 matches 'S') and ($7 matches 'E');
sw8 = FILTER S2 BY ($3 matches 'S') and ($7 matches 'W');

ne8c = FOREACH ne8 GENERATE (float)$0+(float)$1/60+(float)$2/3600,      (float)$4+(float)$5/60+(float)$6/3600;
nw8c = FOREACH nw8 GENERATE (float)$0+(float)$1/60+(float)$2/3600,    -((float)$4+(float)$5/60+(float)$6/3600);
se8c = FOREACH se8 GENERATE -((float)$0+(float)$1/60+(float)$2/3600),   (float)$4+(float)$5/60+(float)$6/3600;
sw8c = FOREACH sw8 GENERATE -((float)$0+(float)$1/60+(float)$2/3600), -((float)$4+(float)$5/60+(float)$6/3600);

ne6 = FILTER S2 BY ($2 matches 'N') and ($5 matches 'E');
nw6 = FILTER S2 BY ($2 matches 'N') and ($5 matches 'W');
se6 = FILTER S2 BY ($2 matches 'S') and ($5 matches 'E');
sw6 = FILTER S2 BY ($2 matches 'S') and ($5 matches 'W');

ne6c = FOREACH ne6 GENERATE (float)$0+(float)$1/60,      (float)$3+(float)$4/60;
nw6c = FOREACH nw6 GENERATE (float)$0+(float)$1/60,    -((float)$3+(float)$4/60);
se6c = FOREACH se6 GENERATE -((float)$0+(float)$1/60),   (float)$3+(float)$4/60;
sw6c = FOREACH sw6 GENERATE -((float)$0+(float)$1/60), -((float)$3+(float)$4/60);

ne4 = FILTER S2 BY ($1 matches 'N') and ($3 matches 'E');
nw4 = FILTER S2 BY ($1 matches 'N') and ($3 matches 'W');
se4 = FILTER S2 BY ($1 matches 'S') and ($3 matches 'E');
sw4 = FILTER S2 BY ($1 matches 'S') and ($3 matches 'W');

ne4c = FOREACH ne4 GENERATE (float)$0,      (float)$2;
nw4c = FOREACH nw4 GENERATE (float)$0,    -((float)$2);
se4c = FOREACH se4 GENERATE -((float)$0),   (float)$2;
sw4c = FOREACH sw4 GENERATE -((float)$0), -((float)$2);

nesw8 = UNION ne8c, nw8c, se8c, sw8c;
nesw6 = UNION ne6c, nw6c, se6c, sw6c;
nesw4 = UNION ne4c, nw4c, se4c, sw4c;

nesw = UNION nesw8, nesw6, nesw4;
STORE nesw INTO '/tmp/nesw';
