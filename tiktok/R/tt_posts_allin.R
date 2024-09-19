# fetch posts from multiple handles 

# 1. Get links from tiktok (link gopher)
# 2. save to proper path with the name as the handle or hashtag
# 3. pass the path and handle in as arguments; run

tt_posts_allin <- function(link_path, handle){
  pacman::p_load(tidyverse, janitor, here, glue)
  source(here("tiktok", "R", "filter_links.R"))
  source(here("tiktok", "R", "get_tt_posts.R"))
  # links
  if (is.null(handle)) {
    links <- filter_links(link_path, handle = handle)
  } else {
    links <- filter_links(glue("{link_path}/{handle}.xlsx"), handle = handle)
  }
  
  # fetch
  tmp <- links |> 
    map(get_tt_posts)
  tmp[!is.na(tmp)] |> 
    bind_rows()
}

# to run # 
# link_path <- here("tiktok", "tiktok_data", "links", "raisingcanes.xlsx")
# 
# out <- tt_posts_allin(link_path, handle = "raisingcanes")
# 
# handles <- c("zaxbys", "raisingcanes", "chipotle", "mcdonalds",
#              "wendys", "tacobell", "chilisofficial", "noodlescompany")
# args <- crossing(link_path = link_path, handle = handles)
# 
# out <- map2(args$link_path, args$handle, tt_posts_allin) |> 
#   set_names(nm = args$handle)
# 
# # save file to processed 
# saveRDS(out, "~/R/zaxbys/social_audit/data/qsr_competitive.rds")
# 
# # let's get follower info
# source(here("tiktok", "R", "get_tt_user.R"))
# handle_data <- handles |> map_dfr(get_tt_user)
# 
# # list to dataframe
# out <- out |> 
#   bind_rows() |> 
#   left_join(select(handle_data, c(handle, followers)), by = c("author_uniqueID" = "handle")) |> 
#   mutate(collect_count = as.numeric(collect_count), 
#          like_rate = like_count/followers, share_rate = share_count/followers, 
#          comment_rate = comment_count/followers, play_rate = play_count/followers,
#          collect_rate = collect_count/followers)
# 
# saveRDS(out, "~/R/zaxbys/social_audit/data/qsr_competitive_df.rds")



