#' Scrape YouTube videos, captions, and video data
#'
#' @param link URL of the video
#' @param get_captions Logical; do you want captions
#' @param get_comments Logical; do you want video metrics and comments
#' @param download_video Logical; download video as mp4
#' @param output_dir String; where to save files
#' @param cleanup_files Logical; if cleanup, vtt file deleted
#'
#' @returns captions in txt file; video metrics in json; subtitles in srt; video in mp4
#' @export
#'
#' @examples
#' \dontrun{
#' youtube_scraper(link = "https://www.youtube.com/watch?v=fpYu9XRZZNw", get_captions = TRUE,get_comments = TRUE, download_video = TRUE)
#' }
youtube_scrape <- function(link, get_captions = TRUE, get_comments = TRUE, download_video = FALSE, output_dir = "youtube/yt_caption_data", cleanup_files = TRUE) {
  # Create the base directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Step 1: Fetch video metadata to get the title
  metadata_cmd <- glue::glue(
    "yt-dlp --skip-download --print \"%(title)s\" \"{link}\""
  )
  message("Fetching video title...")
  title <- system(metadata_cmd, intern = TRUE)
  
  if (length(title) == 0) {
    stop("Failed to fetch the video title.")
  }
  
  # Step 2: Shorten title (if needed)
  max_length <- 50  # Define max length for the title
  title <- gsub("[^a-zA-Z0-9_ -]", "", title)  # Remove problematic characters
  if (nchar(title) > max_length) {
    title <- substr(title, 1, max_length)
  }
  
  message(glue::glue("Using title: {title}"))
  
  # Step 3: Build yt-dlp command
  yt_dlp_cmd <- glue::glue(
    "yt-dlp --output '{output_dir}/{title}'"
  )
  
  # Add options for captions
  if (get_captions) {
    yt_dlp_cmd <- glue::glue(
      "{yt_dlp_cmd} --sub-lang en --write-auto-sub --sub-format vtt"
    )
  }
  
  # Add options for comments
  if (get_comments) {
    yt_dlp_cmd <- glue::glue(
      "{yt_dlp_cmd} --write-comments"
    )
  }
  
  # Add options for video download
  if (download_video) {
    yt_dlp_cmd <- glue::glue(
      "{yt_dlp_cmd} --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --merge-output-format mp4"
    )
  } else {
    yt_dlp_cmd <- glue::glue(
      "{yt_dlp_cmd} --skip-download"
    )
  }
  
  # Add the video link
  yt_dlp_cmd <- glue::glue(
    "{yt_dlp_cmd} '{link}'"
  )
  
  # Step 4: Run yt-dlp command
  message("Running yt-dlp command...")
  system(yt_dlp_cmd)
  
  # Step 5: Process captions into .srt if captions were requested
  if (get_captions) {
    vtt_file <- glue::glue("{output_dir}/{title}.en.vtt")
    srt_file <- glue::glue("{output_dir}/{title}.srt")
    clean_txt_file <- glue::glue("{output_dir}/{title}.txt")
    
    if (file.exists(vtt_file)) {
      # Convert VTT to SRT using ffmpeg
      ffmpeg_cmd <- glue::glue("ffmpeg -i '{vtt_file}' '{srt_file}'")
      message("Converting VTT to SRT...")
      system(ffmpeg_cmd)
      
      # Clean and extract plain text from the SRT file
      if (file.exists(srt_file)) {
        clean_cmd <- paste0(
          "rg -v '^[[:digit:]]+$|^[[:digit:]]{2}:|^$', ",
          "'", srt_file, "' | tr -d '\\r' | rg -N '\\S' | uniq > ",
          "'", clean_txt_file, "'"
        )
        message("Cleaning SRT file and extracting text...")
        system(clean_cmd)
        message(glue::glue("Cleaned captions saved to: {clean_txt_file}"))
        
        # Delete .vtt and .srt files if cleanup is enabled
        if (cleanup_files) {
          message("Deleting temporary files (.vtt and .srt)...")
          if (file.exists(vtt_file)) file.remove(vtt_file)
          # if (file.exists(srt_file)) file.remove(srt_file)
        }
      } else {
        warning("SRT file not found after conversion.")
      }
    } else {
      warning("VTT file not found. Skipping caption processing.")
    }
  }
  
  message("YouTube scraping complete!")
}














