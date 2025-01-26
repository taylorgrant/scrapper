# python function to get tiktok data 
def tiktok_info(URL):
  import yt_dlp
  import pandas as pd
  import time

  # See help(yt_dlp.YoutubeDL) for a list of available options and public functions
  ydl_opts = {'getcomments':True, 'writesubtitles': False}
  with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    info = ydl.extract_info(URL, download=True)
    
    select_dict = {
      'uploader': info['uploader'],
      'id': info['id'],
      'url': info['webpage_url'],
      'timestamp': info['timestamp'],
      'length': info['duration'],
      'post_text': info['title'],
      'view_count': info['view_count'],
      'like_count': info['like_count'],
      'repost_count': info['repost_count'],
      'comment_count': info['comment_count'],
      'music_artist': info['artist'],
      'music_track': info['track'],
      'download_url': info['url']
    }
  df = pd.DataFrame(select_dict, index=[0])
  # time.sleep(1)
  return(df)

