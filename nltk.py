from pig_util import outputSchema
import nltk
 
@outputSchema("top_five:bag{t:(bigram:chararray)}")
def top_5_bigrams(tweets):
    tokenized_tweets = [ nltk.tokenize.WhitespaceTokenizer().tokenize(t[0]) for t in tweets ]
 
    bgm    = nltk.collocations.BigramAssocMeasures()
    finder = nltk.collocations.BigramCollocationFinder.from_documents(tokenized_tweets)
    top_5  = finder.nbest(bgm.likelihood_ratio, 5)
    
    return [ ("%s %s" % (s[0], s[1]),) for s in top_5 ]
