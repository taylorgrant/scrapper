## Scraping Threads

In case there is ever a need, these functions use playwright to crawl
the site. This is pretty basic, and to be honest, some of the times the
post scraper actually grabs the wrong thread.

### Scraping a thread

The thread returns a named list - thread\_data and replies data. There
isn’t a whole lot that’s returned by Threads, and this tries to get the
relevant info.

    dat <- scrape_thread(url = "https://www.threads.net/@koreydior_/post/DFRXN-kt1H9")

    list(dat$thread_data, dat$replies_data[1:4,])

    ## [[1]]
    ## # A tibble: 1 × 5
    ##   username   user_id     date                text                                                    url                      
    ##   <chr>      <chr>       <dttm>              <chr>                                                   <chr>                    
    ## 1 koreydior_ 55587242084 2025-01-25 18:01:38 Are we 100% sure we're meant to be awake in the winter? https://www.threads.net/…
    ## 
    ## [[2]]
    ## # A tibble: 4 × 5
    ##   text                                                                           published_on        username like_count url  
    ##   <chr>                                                                          <dttm>              <chr>         <int> <chr>
    ## 1 Yes. We haven’t lived in cold regions for millions of years, we’ve only been … 2025-01-26 01:16:09 dylanse…          8 http…
    ## 2 So you’re really saying no we’re not but we haven’t figured out a way to slee… 2025-01-26 04:37:01 jordygo…          0 http…
    ## 3 @jobvandoesburg ik wil een petitie starten om alleen in de lente en herfst na… 2025-01-26 05:46:00 mushroo…          1 http…
    ## 4 Is goed hoor! Waar zou ik voor je tekenen? Mijn ooms zeiden altijd dat je pas… 2025-01-26 06:55:50 jobvand…          1 http…

It is possible to scrape multiple threads, but the replies data doesn’t
have a way of identifying which post the reply is being made to. So
running across multiple threads can be a little difficult.

To do so, it could be done like this:

    urls <- c("https://www.threads.net/@natgeo/post/DFSt1c2soIH",
              "https://www.threads.net/@natgeo/post/DFPwfxNt-Fv")

    # Apply safe_scrape_thread to the list of URLs
    results <- map(urls, scrape_thread)

    # Filter out failed results
    results <- compact(results)

    # Combine the results
    all_threads <- map_df(results, ~.x$thread_data)
    all_replies <- map_df(results, ~.x$replies_data) # may want to keep replies in separate lists 

### Scraping the user profile

The user profile scraper returns a named list - profile\_data and
recent\_threads. The user data is basic, the threads looks to be the 30
most recent threads posted from that account.

    dat <- scrape_profile(url = "https://www.threads.net/@natgeo/")

    list(dat$profile_data, dat$recent_threads[1:3,])

    ## [[1]]
    ## # A tibble: 1 × 5
    ##   full_name           username bio                                   bio_link                        followers
    ##   <chr>               <chr>    <chr>                                 <chr>                               <int>
    ## 1 National Geographic natgeo   Inspiring the explorer in everyone 🌎 https://on.natgeo.com/instagram  15603033
    ## 
    ## [[2]]
    ## # A tibble: 3 × 5
    ##   text                                                                           published_on        username like_count url  
    ##   <chr>                                                                          <dttm>              <chr>         <int> <chr>
    ## 1 Brb, planning our next snowy escape... ⛷️ Where are your favorite ski spots?    2025-01-26 06:38:30 natgeo          284 http…
    ## 2 Now this is how to engage students! 🕷️                                          2025-01-25 03:04:02 natgeo          342 http…
    ## 3 Gazing up at the sky and thinking about how there are more stars in the unive… 2025-01-24 06:00:05 natgeo          920 http…
