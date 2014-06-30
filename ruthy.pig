wplines = LOAD 'wp4_top5.xml' USING PigStorage(';') AS (title:chararray, body:chararray);
BLinks = FOREACH wplines GENERATE FLATTEN(REGEX_EXTRACT_ALL(body, '.*<link>(.*)</link>'.*));
STORE BLinks INTO '/tmp/B';

--ruthy = FILTER wplines BY body MATCHES '.*Accessible.*';

