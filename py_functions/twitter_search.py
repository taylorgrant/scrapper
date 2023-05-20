 # Scrape Twitter
def twitter_search(n, query):
  import snscrape.modules.twitter as sntwitter
  import pandas as pd

  # creating list to append tweet data to
  tweets_list = []

  # use scraper
  for i,tweet in enumerate(sntwitter.TwitterSearchScraper(query).get_items()):
    if i >= n:
      break
    try:
      tweetMedia = tweet.links[0].url # .previewUrl if you want previewUrl
    except:
      tweetMedia = tweet.links
    tweets_list.append([tweet.date, tweet.url, tweet.rawContent, tweet.user.username, 
    tweet.user.rawDescription, tweet.user.verified, tweet.user.followersCount, 
    tweet.user.friendsCount, tweet.user.statusesCount, tweet.likeCount, 
    tweet.replyCount, tweet.retweetCount, tweet.quoteCount, tweet.viewCount,
    tweet.bookmarkCount, tweet.conversationId,
    tweet.hashtags, tweet.cashtags, tweetMedia])
  
  # creating dataframe
  tweets_df = pd.DataFrame(tweets_list, columns = ['datetime', 'tweet_url', 'text',
  'username', "user_description", "user_verified", "user_followerCount", 
  "user_friendsCount", "user_statusCount", 'tweet_likeCount', 
  'tweet_replyCount', 'tweet_retweetCount', 'tweet_quoteCount', "tweet_viewCount",
  "tweet_bookmarkCount", "tweet_conversationId", "tweet_hashtags", "tweet_cashtags",
  "tweet_media"])
  return(tweets_df)


