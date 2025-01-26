ig_parse_user <- function(data) {
  # get data on the account
  account_data <- rjsoncons::jmespath(data, "data.user.{
        name: full_name,
        username: username,
        id: id,
        category: category_name,
        business_category: business_category_name,
        phone: business_phone_number,
        email: business_email,
        bio: biography,
        bio_links: bio_links[].url,
        homepage: external_url,        
        followers: edge_followed_by.count,
        follows: edge_follow.count,
        facebook_id: fbid,
        is_private: is_private,
        is_verified: is_verified,
        profile_image: profile_pic_url_hd,
        video_count: edge_felix_video_timeline.count,
        videos: edge_felix_video_timeline.edges[].node.{
          id: id,
          title: title,
          shortcode: shortcode,
          thumb: display_url,
          url: video_url,
          views: video_view_count,
          tagged: edge_media_to_tagged_user.edges[].node.user.username,
          captions: edge_media_to_caption.edges[].node.text,
          comments_count: edge_media_to_comment.count,
          comments_disabled: comments_disabled,
          taken_at: taken_at_timestamp,
          likes: edge_liked_by.count,
          location: location.name,
          duration: video_duration
        },
      image_count: edge_owner_to_timeline_media.count,
      images: edge_owner_to_timeline_media.edges[].node.{
        id: id, 
        title: title,
        shortcode: shortcode,
        src: display_url,
        url: video_url,
        views: video_view_count,
        tagged: edge_media_to_tagged_user.edges[].node.user.username,
        captions: edge_media_to_caption.edges[].node.text,
        comments_count: edge_media_to_comment.count,
        comments_disabled: comments_disabled,
        taken_at: taken_at_timestamp,
        likes: edge_liked_by.count,
        location: location.name,
        accesibility_caption: accessibility_caption,
        duration: video_duration
    },
      saved_count: edge_saved_media.count,
      related_profiles: edge_related_profiles.edges[].node.username
                                   
}") |> 
    jsonlite::fromJSON() 
  
  # get post data
  post_data <- rjsoncons::jmespath(data, "data.user.edge_owner_to_timeline_media.edges[].node.{
         post_date: taken_at_timestamp, 
         typename: __typename,
         type: is_video,
         id: id,
         shortcode: shortcode,
         thumbnail: thumbnail_src,
         video_url: video_url,
         caption: edge_media_to_caption.edges[].node.text,
         video_viewcount: video_view_count,
         comment_count: edge_media_to_comment.count,
         like_count: edge_liked_by.count,
         location: location.name,
         music_artist: clips_music_attribution_info.artist_name,
         song_name: clips_music_attribution_info.song_name
}"
  ) |> 
    jsonlite::fromJSON()  
  # mutate(post_date = as.POSIXct(post_date, origin = "1970-01-01"))
  
  list(account_data = account_data, post_data = post_data)
}
