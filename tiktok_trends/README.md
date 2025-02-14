
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Note

This doesn’t work anymore. TikTok has changed their hashtag data setup.

## TikTok Hashtags

TikTok has a [Hashtag
Discovery](https://ads.tiktok.com/business/creativecenter/inspiration/popular/hashtag/pc/en)
site that updates on a daily basis with hashtags that are trending over
a 7-, 30-, or 120-day window. Due to the the nature of TikTok however,
many hashtags are ephemeral, some are seasonal, and others are just
random.

#### Data

But TikTok does provide deeper analytics for its hashtags and it’s
trivial to get the data from its analytics pages. I’ve written a
function
[trending_hashtags.R](https://github.com/taylorgrant/scrapper/blob/main/tiktok_trends/R/trending_hashtags.R)
that pulls this data from the website script, parses it, and cleans it.
The data is returned in a named list and it includes:

- Monthly trend for 3 years
- \#hashtag posts last 3 years
- Total posts for \#hashtag
- \#hashtag ideo views last 3 years
- Total video views for \#hashtag
- % interest split in \#hashtag by age cohort
- Other topics of interest to audience engaging with \#hashtag
- Index of top 10 countries with interest in \#hashtag
- 5 related \#hashtags
- 3 year trends for each related \#hashtag

#### Shiny App

To make it even easier to use, I’ve also written a [Shiny
app](https://github.com/taylorgrant/scrapper/blob/main/tiktok_trends/app.R)
that allows for a user to enter any hashtag and have the app visualize
all of the data. TikTok’s analytics also provides 5 related hashtags;
the function also hits the site for the trend data for each of these
hashtags so that a user can easily visualize the popularity of each
hashtag side by side. The pairwise correlations of each hashtag are also
provide in the app as well.
