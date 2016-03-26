# Import classes
import tweepy, time
 
# Consumer keys and access tokens, used for OAuth
consumer_key = 'OXMzXnCySStI19mMXOusX0e6O'
consumer_secret = 'DLi82wPr9ytwtutYWo8u8haKxoJQUQs3ww6Oyj32RprdLPLe7n'
access_token = '713500052329787397-XSMFh3YbXFOEfbrD8zsfmRrYUjPBolt'
access_token_secret = '1zfymH1OtEHU6MpDKZnSBW4ElL9mSSZV83NRQ6AgRCYf9'
 
# OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
 
# Creation of the actual interface, using authentication
api = tweepy.API(auth)

# File the bot will tweet from
filename=open('aforismos.txt','r')

f=filename.readlines()

filename.close()


#Tweet a line every hour
for line in f:
     api.update_status(line)
     print (line)
     time.sleep(600)