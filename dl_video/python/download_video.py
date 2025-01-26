def download_video(URL, output_directory, subtitles_langs=None):
    import yt_dlp

    # Specify download options
    ydl_opts = {
        'outtmpl': f'{output_directory}/%(title)s.%(ext)s',  # Save in output directory with video title
        'format': 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best',  # Prefer MP4 for both video and audio
        'merge_output_format': 'mp4',  # Ensure final output is in MP4 format
        'postprocessors': [{  # Merge audio and video into MP4
            'key': 'FFmpegVideoConvertor',
            'preferedformat': 'mp4'
        }],
        'postprocessor_args': ['-movflags', 'faststart'],  # Optimize for progressive streaming
        'cleanup': True,  # Automatically delete .webm and .m4a files after merging
        'quiet': False,  # Show logs (set to True to suppress)
        'no_warnings': True  # Suppress warnings
    }

    # Add subtitle options if subtitles_langs is provided
    if subtitles_langs:
        ydl_opts.update({
            'subtitleslangs': subtitles_langs,  # Specify subtitle languages (e.g., ['en'])
            'writesubtitles': True, # Download subtitles if available
            'writeautomaticsub': True, 
            'subtitlesformat': 'srt'           # Save subtitles as SRT files
        })

    # Initialize downloader and download the video
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([URL])
