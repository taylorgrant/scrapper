
## Instagram scraping

These are a series of functions primarily written in Python and then
using R wrappers to call and process the data.

#### User Level

The `ig_scrape_user()` function will pull the basic account details of a
username. There is a helper function `ig_parse_user()` that parses the
returned data. I’m just manually pulling things into a tibble for now.

``` r
user <- ig_scrape_user("bmw")
user_parsed <- ig_parse_user(user)
tibble(name = user_parsed$account_data$name, username = user_parsed$account_data$username,
       id = user_parsed$account_data$id,
       category = user_parsed$account_data$category, bio = user_parsed$account_data$bio,
       followers = user_parsed$account_data$followers, follows = user_parsed$account_data$follows,
       video_count = user_parsed$account_data$video_count, image_count = user_parsed$account_data$image_count)
#> # A tibble: 1 × 8
#>   name  username id       bio          followers follows video_count image_count
#>   <chr> <chr>    <chr>    <chr>            <int>   <int>       <int>       <int>
#> 1 BMW   bmw      43109246 "The offici…  40487247      73          42       12065
```

#### Post Level

At the post level, the `scrape_instagram()` function will pull post
level data. There are two arguments: `user_name` and `max_pages`.
`user_name` is the public handle of the account. `max_pages` is the
total number of pages of data to capture. By defaul, each page contains
data for 12 posts.

``` r
scrape_instagram("bmw", max_pages = 1) |> data.frame()
#> Scraping total 12065 posts of user 43109246
#> Scraping detailed data for post: DE5HUT1oKn-
#> Successfully parsed post: DE5HUT1oKn-
#> Scraping detailed data for post: DE4yuAJK_T2
#> Successfully parsed post: DE4yuAJK_T2
#> Scraping detailed data for post: DE8ECwPoM3H
#> Successfully parsed post: DE8ECwPoM3H
#> Scraping detailed data for post: DFTBfotIM12
#> Successfully parsed post: DFTBfotIM12
#> Scraping detailed data for post: DFSwXU6IegO
#> Successfully parsed post: DFSwXU6IegO
#> Scraping detailed data for post: DFSU1MJIVdZ
#> Successfully parsed post: DFSU1MJIVdZ
#> Scraping detailed data for post: DFST7hYIJys
#> Successfully parsed post: DFST7hYIJys
#> Scraping detailed data for post: DFQqb6-o-JI
#> Successfully parsed post: DFQqb6-o-JI
#> Scraping detailed data for post: DFQcu_LoWxj
#> Successfully parsed post: DFQcu_LoWxj
#> Scraping detailed data for post: DFQLjEqoH_L
#> Successfully parsed post: DFQLjEqoH_L
#> Scraping detailed data for post: DFPwFkQIOsW
#> Successfully parsed post: DFPwFkQIOsW
#> Scraping detailed data for post: DFOMg_CoP_l
#> Successfully parsed post: DFOMg_CoP_l
#>              post_date                                     url
#> 1  2025-01-16 08:01:09 https://www.instagram.com/p/DE5HUT1oKn-
#> 2  2025-01-16 05:01:14 https://www.instagram.com/p/DE4yuAJK_T2
#> 3  2025-01-17 11:30:00 https://www.instagram.com/p/DE8ECwPoM3H
#> 4  2025-01-26 09:30:00 https://www.instagram.com/p/DFTBfotIM12
#> 5  2025-01-26 07:00:00 https://www.instagram.com/p/DFSwXU6IegO
#> 6  2025-01-26 03:55:17 https://www.instagram.com/p/DFSU1MJIVdZ
#> 7  2025-01-26 02:52:09 https://www.instagram.com/p/DFST7hYIJys
#> 8  2025-01-25 11:30:00 https://www.instagram.com/p/DFQqb6-o-JI
#> 9  2025-01-25 09:30:00 https://www.instagram.com/p/DFQcu_LoWxj
#> 10 2025-01-25 07:00:00 https://www.instagram.com/p/DFQLjEqoH_L
#> 11 2025-01-25 03:00:00 https://www.instagram.com/p/DFPwFkQIOsW
#> 12 2025-01-24 12:30:00 https://www.instagram.com/p/DFOMg_CoP_l
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    caption
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         We shine in the dark ✨\n\nThe BMW i7. 100% electric. \n#THEi7 #BMW #BMWElectric
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           What we mean when we say self-care 🧽\n\nThe BMW i7. 100% electric. \n#THEi7 #BMW #BMWElectric
#> 3  Our New Years Resolution for 2025 was to be more well-behaved.\n\nGuess they call today ‘Ditch your resolution day’ for a reason 🤷‍♂️\n\nSee what we got up to at @bmwwelt 👀\n\n#BMW #BMWM #BMWWELT #THEM5 #BMWIndividual \n\nThe BMW M5 Sedan: Mandatory information according to German law ’Pkw-EnVKV’ based on WLTP: energy consumption weighted combined: 25.5 kWh/100 km and 1.7 l/100 km; CO₂ emissions weighted combined: 39 g/km; CO2 classes: with discharged battery G; weighted combined B; Fuel consumption with depleted battery combined: 10.3 l/100km; electric range: 67 km\n\nPaint finish shown: BMW Individual special paint Speed Yellow solid. Check the link in bio for the BMW Individual Visualizer to see more BMW Individual colour options.
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                               Marina Bay Blue really pops in the snow.\n📸: @mehmotnc #BMWRepost\n\nThe BMW X6 M Competition.\n#THEX6 #BMWM #X6 #BMW #MPower\n\nMandatory information according to german law ’Pkw-EnVKV’ based on WLTP: energy consumption\ncombined: 12,9 l/100 km; CO₂ emissions combined: 292 g/km; CO2-class(es): G
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                            Bad weather? Snow worries for me.\n📸 @ondrejstaidl\n🚘 @alex.hilli\n\nThe BMW i5 M60 Touring. 100% electric.\n#THEi5 #BMW #BMWElectric\n\nMandatory information according to german law ’Pkw-EnVKV’ based on WLTP: energy consumption\ncombined: 20,9 kWh/100 km; CO₂ emissions combined: 0 g/km; CO2-class: A; electric range: 442-\n441 km
#> 6                                                   All aboard the boat to pure adrenaline. ⛴️\n📍Çanakkale, Turkey.\n📸 @berkmercanci #BMWRepost\n\nThe BMW M5 Sedan.\nThe BMW M2 Coupé.\n#THEM5 #THEM2 #BMW #M5 #M2 #BMWM #MHybrid\n\nMandatory information according to German law ’Pkw-EnVKV’ based on WLTP: energy consumption\nweighted combined: 26,8 kWh/100 km and 1,9 l/100 km; CO₂ emissions weighted combined: 43\ng/km; CO2 classes: with discharged battery G; weighted combined B; Fuel consumption with\ndepleted battery combined: 10,7 l/100km; electric range: 63 km\n\nMandatory information according to german law ’Pkw-EnVKV’ based on WLTP: energy consumption\ncombined: 10,2-9,8 l/100 km; CO₂ emissions combined: 231-222 g/km; CO2-class(es): G
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            It’s more than a car. It’s a way of life.\n\n#BMWClassic #BMW #ClassicSundays
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                              A winter adventure - yes please.\n\nThe BMW i5 eDrive40. 100% electric.\n#THEi5 #BMW #BMWElectric #BMWAccessories\n\nMandatory information according to german law ’Pkw-EnVKV’ based on WLTP: energy consumption\ncombined: 18,9-18,8 kWh/100 km; CO₂ emissions combined: 0 g/km; CO2-class: A; electric range:\n500-498 km
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      Feeling cold but never frozen in place.\n📸 @double7media #BMWRepost\n🚘 @dustin22_2\n\nThe 2023 BMW M4 Competition.\n#THEM4 #BMWM #M4 #BMW #MPower
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     So fresh and so clean.\n🚘: @_tomasbrabec\n📸: @andrew.vana #BMWRepost\n\nThe 2023 BMW M3.\n#THEM3 #BMW #M3 #MPower
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                      Those crisp winter drives hit different ❄️\n📸: @360drivesi #BMWRepost\n\nThe BMW M3 Competition Sedan with M xDrive.\n#THEM3 #BMW #M3 #MPower\n\nMandatory information according to German law ’Pkw-EnVKV’ based on WLTP: energy consumption\ncombined: 10.2-10.1 l/100 km; CO₂ emissions combined: 230-228 g/km; CO2-class(es): G
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Fast is about to meet faster.\n\n#BMW #BMWM #MPower #TheUltimateOneCarSolution
#>     views   plays  likes comments video_duration
#> 1  471660 2126615 193614     1779          8.811
#> 2  579505 2709848  60630      477         16.939
#> 3  214832 1387809  57431      348         50.409
#> 4   61586  508574  19086      140          7.333
#> 5     NaN     NaN  39965      260            NaN
#> 6     NaN     NaN 106351      409            NaN
#> 7     NaN     NaN  36075      103            NaN
#> 8     NaN     NaN  61570      200            NaN
#> 9     NaN     NaN  83472      448            NaN
#> 10    NaN     NaN 115286      705            NaN
#> 11    NaN     NaN  77538      497            NaN
#> 12    NaN     NaN 152388      523            NaN
#>                         collaborators
#> 1                                    
#> 2                                    
#> 3  bmw, bmwwelt, redbulldriftbrothers
#> 4                                    
#> 5                                    
#> 6                                    
#> 7                           bmw, bmwm
#> 8                                    
#> 9                                    
#> 10                                   
#> 11                                   
#> 12                                bmw
#>                                                       hashtags
#> 1                                   #THEi7, #BMW, #BMWElectric
#> 2                                   #THEi7, #BMW, #BMWElectric
#> 3                #BMW, #BMWM, #BMWWELT, #THEM5, #BMWIndividual
#> 4                #BMWRepost, #THEX6, #BMWM, #X6, #BMW, #MPower
#> 5                                   #THEi5, #BMW, #BMWElectric
#> 6  #BMWRepost, #THEM5, #THEM2, #BMW, #M5, #M2, #BMWM, #MHybrid
#> 7                           #BMWClassic, #BMW, #ClassicSundays
#> 8                  #THEi5, #BMW, #BMWElectric, #BMWAccessories
#> 9                #BMWRepost, #THEM4, #BMWM, #M4, #BMW, #MPower
#> 10                      #BMWRepost, #THEM3, #BMW, #M3, #MPower
#> 11                      #BMWRepost, #THEM3, #BMW, #M3, #MPower
#> 12            #BMW, #BMWM, #MPower, #TheUltimateOneCarSolution
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 media_link
#> 1        https://scontent-sjc3-1.cdninstagram.com/o1/v/t16/f2/m86/AQOg1Ky9xbfVECX3bvhFUtdBHKv7o9mX-1dgqCp4K31XZS7G5Xz4KJsC0qNnaLu3H1fTz7W2mpzOvtSV88_SZej34JjJ5E3IW7RstqM.mp4?stp=dst-mp4&efg=eyJxZV9ncm91cHMiOiJbXCJpZ193ZWJfZGVsaXZlcnlfdnRzX290ZlwiXSIsInZlbmNvZGVfdGFnIjoidnRzX3ZvZF91cmxnZW4uY2xpcHMuYzIuNzIwLmJhc2VsaW5lIn0&_nc_cat=110&vs=568456509361022_967454477&_nc_vs=HBksFQIYUmlnX3hwdl9yZWVsc19wZXJtYW5lbnRfc3JfcHJvZC9FQjQwNkNFMDczMTREOEE5QkVBNDQxMjgyQ0E1Rjk4MV92aWRlb19kYXNoaW5pdC5tcDQVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dHemVNeHhBcUxpMDVOa0VBSF8yTUNjanMxUWRicV9FQUFBRhUCAsgBACgAGAAbABUAACaKipbwtoSyPxUCKAJDMywXQCGZmZmZmZoYEmRhc2hfYmFzZWxpbmVfMV92MREAdf4HAA%3D%3D&ccb=9-4&oh=00_AYBjqossB4mC--ohkEWQ8WOxKeJNwrUaox1M5yUbf1Y0UQ&oe=67986E2E&_nc_sid=d885a2
#> 2       https://scontent-sjc3-1.cdninstagram.com/o1/v/t16/f2/m86/AQOmrQsFDZZcfiDCWNGWgZaxSumLzvmxoGqXk-14EXiOGUHo4THo8dic5zt_6uizcKkf-P6tLqEHT7Vis_SCnGhz8wrXy2jX_OZuh-Q.mp4?stp=dst-mp4&efg=eyJxZV9ncm91cHMiOiJbXCJpZ193ZWJfZGVsaXZlcnlfdnRzX290ZlwiXSIsInZlbmNvZGVfdGFnIjoidnRzX3ZvZF91cmxnZW4uY2xpcHMuYzIuNzIwLmJhc2VsaW5lIn0&_nc_cat=111&vs=925850083087482_1767228440&_nc_vs=HBksFQIYUmlnX3hwdl9yZWVsc19wZXJtYW5lbnRfc3JfcHJvZC9COTQ3NTkyNEMzNjk1QzQ2MTEzMDBBREM5NzA1QkQ5MV92aWRlb19kYXNoaW5pdC5tcDQVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dEcUZNaHgwdWVkMUdaa0JBT01vOGxWa3VtZ2xicV9FQUFBRhUCAsgBACgAGAAbABUAACaGh5nIpfuwQBUCKAJDMywXQDDu2RaHKwIYEmRhc2hfYmFzZWxpbmVfMV92MREAdf4HAA%3D%3D&ccb=9-4&oh=00_AYBd4DrNHTbUKoKDMh5ousP_wmiCa1Fv3V0XYhDWMZ3F-w&oe=67988DF3&_nc_sid=d885a2
#> 3       https://scontent-sjc3-1.cdninstagram.com/o1/v/t16/f2/m86/AQO4VQZ6QpH_ypHix19iBcdFTZWYK98y3vwnLoiqxFWwSZfKeTE0mMvmtV7GR-cyRAxMEBAh5Y6qj8q4to5d2A5oztcEhm1X0s6QlUg.mp4?stp=dst-mp4&efg=eyJxZV9ncm91cHMiOiJbXCJpZ193ZWJfZGVsaXZlcnlfdnRzX290ZlwiXSIsInZlbmNvZGVfdGFnIjoidnRzX3ZvZF91cmxnZW4uY2xpcHMuYzIuNzIwLmJhc2VsaW5lIn0&_nc_cat=108&vs=963464292512221_2799950118&_nc_vs=HBksFQIYUmlnX3hwdl9yZWVsc19wZXJtYW5lbnRfc3JfcHJvZC8yNjREREU2MkNFQzc4NkQ1Qjg1QjhCMDkzRjFGNEU5RF92aWRlb19kYXNoaW5pdC5tcDQVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dPdWFPeHhvZ1Bpc0VERUNBQV9ITU03N29ueHZicV9FQUFBRhUCAsgBACgAGAAbABUAACaC4pbk1P6yPxUCKAJDMywXQEkzMzMzMzMYEmRhc2hfYmFzZWxpbmVfMV92MREAdf4HAA%3D%3D&ccb=9-4&oh=00_AYDAGwK52sbmsCdkYfQcbmxLKCQGxi7NRLniL0ITL2ft4w&oe=67988672&_nc_sid=d885a2
#> 4  https://scontent-sjc3-1.cdninstagram.com/o1/v/t16/f2/m86/AQNv351-KljUBM2GnFd2plXLpqLDRIMgRxCkzpTubvriSKhwxxHeetfL9TfLCIoGjdCWUl7l5Q5MNV5-Mc3BDJPDSl3mZMblNVQEF8A.mp4?stp=dst-mp4&efg=eyJxZV9ncm91cHMiOiJbXCJpZ193ZWJfZGVsaXZlcnlfdnRzX290ZlwiXSIsInZlbmNvZGVfdGFnIjoidnRzX3ZvZF91cmxnZW4uY2xpcHMuYzIuNzIwLmJhc2VsaW5lIn0&_nc_cat=109&vs=612645031350361_620302679&_nc_vs=HBksFQIYUmlnX3hwdl9yZWVsc19wZXJtYW5lbnRfc3JfcHJvZC80QTQ1RUVEM0YwQjk1MjkwQTE4MzlCMTg3MTVEQTI4Nl92aWRlb19kYXNoaW5pdC5tcDQVAALIAQAVAhg6cGFzc3Rocm91Z2hfZXZlcnN0b3JlL0dOazJUUno0Q2NaZHpvNExBRV83OWgydXA4cEJicV9FQUFBRhUCAsgBACgAGAAbABUAACbYt%2FvSj%2BfFPxUCKAJDMywXQB1U%2FfO2RaIYEmRhc2hfYmFzZWxpbmVfMV92MREAdf4HAA%3D%3D&ccb=9-4&oh=00_AYD2udIh5MmwZE2Aq20yYDMlhL1mU0td_LRssedZfpOytg&oe=67987135&_nc_sid=d885a2
#> 5                                                                                                                                                                                                                                                                                                                                                                                                       https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474657834_18484825237037247_7827805593010534167_n.jpg?stp=dst-jpg_e15_fr_p1080x1080_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=VDRr3bA87nIQ7kNvgEbuNUT&_nc_gid=42ca5cb6507141d59411585ad2d7fa0e&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYDQ6Xt0hyEHdUsAeA6EFqPlg2n0_NcuxLxM9LfDVkP1cA&oe=679C7B49&_nc_sid=d885a2
#> 6                                                                                                                                                                                                                                                                                                                                                                                                        https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474805634_18484824322037247_557247908832938639_n.jpg?stp=dst-jpg_e15_fr_p1080x1080_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=iQifPvF3EI4Q7kNvgH0r3SP&_nc_gid=c5b44f9f3ca8412eb7bb61391caf5286&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYA3daSZuteNL-vAiwsNL8bLlUp47ThoqlsnexeMX3Nhmg&oe=679C73BA&_nc_sid=d885a2
#> 7                                                                                                                                                                                                                                                                                                                                                                                                    https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/475236844_18483681286032114_594961983926783982_n.jpg?stp=dst-jpg_e35_p1080x1080_sh0.08_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=wYN9NkPsfKkQ7kNvgECa7XO&_nc_gid=21eeaae80c93462a923ef56cfe5acd37&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYAHZEileDvrv9d5nNDtg69asHLDma953q1EI9jNzGC57A&oe=679C8E5A&_nc_sid=d885a2
#> 8                                                                                                                                                                                                                                                                                                                                                                                                       https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474732293_18484823764037247_4228128421408462458_n.jpg?stp=dst-jpg_e15_fr_p1080x1080_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=sE-0m2ZADowQ7kNvgG1URew&_nc_gid=8fdecad7de0046089ddafeb7c2f14158&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYBX05qm3T7KkgRzve5fwDSQwhMOiPn_WGXH_YHFSk139g&oe=679C911D&_nc_sid=d885a2
#> 9                                                                                                                                                                                                                                                                                                                                                                                                       https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474750161_18484823428037247_9115066258169695892_n.jpg?stp=dst-jpg_e15_fr_p1080x1080_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=Qw0QmlufGD4Q7kNvgGJ07LI&_nc_gid=d7c4db032f4f4441bbce938fa82c32de&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYAasNxdKvvhonoWn-s0lPPSps4EeCivhZvPCKhbWeCwaQ&oe=679C8F98&_nc_sid=d885a2
#> 10                                                                                                                                                                                                                                                                                                                                                                                                      https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474969939_18484823107037247_8644078531832889838_n.jpg?stp=dst-jpg_e15_fr_p1080x1080_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=mS2qnjmQ3qMQ7kNvgF7W12Z&_nc_gid=7f6813efc6e44953b6af1c1762000c96&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYA78tu_pcLZHlDguGatMLwfM-ATYQdE2f6BWvtSq-GPbw&oe=679C85CB&_nc_sid=d885a2
#> 11                                                                                                                                                                                                                                                                                                                                                                                                  https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474880963_18484822612037247_2350622925101735729_n.jpg?stp=dst-jpg_e35_p1080x1080_sh0.08_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=1o_Ke_y9WTQQ7kNvgGTSjrf&_nc_gid=9b7c73b3f7d94ddcaf85079c6b066443&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYAs3oVBRJX0mtWmVZ-vBfbgNbg22khP5ew1IfR3nRohHw&oe=679C8B29&_nc_sid=d885a2
#> 12                                                                                                                                                                                                                                                                                                                                                                                                  https://scontent-sjc3-1.cdninstagram.com/v/t51.2885-15/474823030_18486240148001907_1436243674484241355_n.jpg?stp=dst-jpg_e35_p1080x1080_sh0.08_tt6&_nc_ht=scontent-sjc3-1.cdninstagram.com&_nc_cat=1&_nc_ohc=dNfvvdLPCloQ7kNvgH0pqeA&_nc_gid=a4d8da7a7b37498fb56a0e90c25539c3&edm=ANTKIIoBAAAA&ccb=7-5&oh=00_AYCr3JNvhlV4mMb6q4hLGyZ6p63KXHSKvad20g3ylLD77Q&oe=679C8234&_nc_sid=d885a2
#>            link_expiry
#> 1  2025-01-27 21:42:06
#> 2  2025-01-27 23:57:39
#> 3  2025-01-27 23:25:38
#> 4  2025-01-27 21:55:01
#> 5  2025-01-30 23:27:05
#> 6  2025-01-30 22:54:50
#> 7  2025-01-31 00:48:26
#> 8  2025-01-31 01:00:13
#> 9  2025-01-31 00:53:44
#> 10 2025-01-31 00:11:55
#> 11 2025-01-31 00:34:49
#> 12 2025-01-30 23:56:36
```
