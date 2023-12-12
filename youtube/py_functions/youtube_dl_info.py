def youtube_dl_info(URL):
  import json
  import yt_dlp

  # See help(yt_dlp.YoutubeDL) for a list of available options and public functions
  ydl_opts = {'getcomments':True}
  with yt_dlp.YoutubeDL(ydl_opts) as ydl:
      info = ydl.extract_info(URL, download=False)
      return(info)
