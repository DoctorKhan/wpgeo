REGISTER ‘<python_file>’ USING streaming_python AS nltk_udfs;
 
tweets =  LOAD 's3n://twitter-gardenhose-mortar/tweets' 
         USING org.apache.pig.piggybank.storage.JsonLoader(
                  'text: chararray, place:tuple(name:chararray)');
 
-- Group the tweets by place name and use a CPython UDF to find the top 5 bigrams
-- for each of these places.
bigrams_by_place = FOREACH (GROUP tweets BY place.name) GENERATE
                        group AS place:chararray, 
                        nltk_udfs.top_5_bigrams(tweets.text), 
                        COUNT(tweets) AS sample_size;
 
top_100_places = LIMIT (ORDER bigrams_by_place BY sample_size DESC) 100;
 
STORE top_100_places INTO '<your_output_path>';
