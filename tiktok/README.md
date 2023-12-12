
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Tiktok scraping

**Needed to run:**

Most of the code is written in R, but it also uses some Python, and it
also requires [yt-dlp](https://github.com/yt-dlp/yt-dlp) to be
installed. Use the `reticulate` package to create a new conda
environment `conda_create('env-name')` and then install everything
within that environment using `conda_install()`. To ensure that the
proper conda environment is used, either set the .Renviron or use
`Sys.setenv(RETICULATE_PYTHON=dir/to/env)` at the top of the code.

**Folder structure**

``` r
├── tiktok
│   ├── R
│   │   ├── clean_links.R
│   │   ├── tiktok_full.R
│   │   └── tiktok_scrape.R
│   ├── py_functions
│   │   └── tiktok_info.py
│   └── tiktok_data
│       ├── links
│       └── processed
```

#### Harvesting Tiktok URLs

As of right now, yt-dlp can’t just access a specific TikTok page and
grab the relevant urls; we have to feed the urls into the function. To
harvest, I to use the [Link
Gopher](https://chrome.google.com/webstore/detail/link-gopher/bpjdkodgnbfalgghnbeggfbfjpcfamkf)
extension for Chrome. Go the page of interest - whether that’s a handle
(e.g., [BMW](https://www.tiktok.com/@bmw?lang=en)) or a hashtag (e.g.,
[\#dumplings](https://www.tiktok.com/search?q=%23dumplings)) - and
manually scroll down through the posted content, allowing the posts to
load. After loading enough posts, use the Link Gopher extension to grab
all urls.

1.  Copy and paste all of them to a .csv or .xlsx file.
2.  Make sure the column header is titled - “links”
3.  To work within the folder structure as it’s set up, save this file
    to the `/tiktok_data/links` folder using the naming convention -
    `{handle}.[csv | xlsx]` or `{hashtag}.[csv | xlsx]`. The naming
    convention doesn’t matter a whole lot since only the post urls will
    be kept, but it will make a difference when saving - if it’s a
    handle, it will save as `{handle}.xlsx` and `{handle}.rds`, but if
    it’s a hashtag the file will prepend a `hashtag_{hashtag}.` to the
    front of the filename.

#### To Run

Once the TikTok urls are saved in the `/tiktok_data/links/` folder,
everything else runs through the `/R/tiktok_full.R` file. It will source
the other functions, de-dupe the posts, and save two files - .rds and
.xlsx.

#### Output

When run, the data looks like the below. URLs aren’t showing up in this
table, but they’re included as well.

<table>
<thead>
<tr>
<th style="text-align:left;">
uploader
</th>
<th style="text-align:left;">
id
</th>
<th style="text-align:left;">
url
</th>
<th style="text-align:left;">
timestamp
</th>
<th style="text-align:right;">
length
</th>
<th style="text-align:left;">
post_text
</th>
<th style="text-align:right;">
view_count
</th>
<th style="text-align:right;">
like_count
</th>
<th style="text-align:right;">
repost_count
</th>
<th style="text-align:right;">
comment_count
</th>
<th style="text-align:left;">
music_artist
</th>
<th style="text-align:left;">
music_track
</th>
<th style="text-align:left;">
download_url
</th>
<th style="text-align:left;">
hashtags
</th>
<th style="text-align:left;">
at_mentions
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
bmw
</td>
<td style="text-align:left;">
7311347054339558688
</td>
<td style="text-align:left;">
<https://www.tiktok.com/@6811960716250203142/video/7311347054339558688>
</td>
<td style="text-align:left;">
2023-12-11 14:40:47
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
The i7 is a paid actor \#BMWi7 \#carsoftiktok \#ThisIsForwardism
\#bmwlove \#fy The \#BMW i7 xDrive60: Power consumption/100 km, CO2
emission/km, weighted comb.: 19.6–18.4 kWh, 0 g. Electric range: 590–625
km. According to WLTP, b.mw/Further_Info.
</td>
<td style="text-align:right;">
10426
</td>
<td style="text-align:right;">
847
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:left;">
Tiktok / IG strategy 🚀
</td>
<td style="text-align:left;">
original sound
</td>
<td style="text-align:left;">
<https://v16m-us.tiktokcdn.com/76ed922db436aac6b03a496e6a38137f/65780fe6/video/tos/useast2a/tos-useast2a-ve-0068c001-euttp/oQyRI3rCABitSolYiHwAPi91fhnpFEuII4uv0I/?a=1180&ch=0&cr=13&dr=0&lr=all&cd=0%7C0%7C0%7C&cv=1&br=952&bt=476&bti=OHYpOTY0Zik3OjlmOm01MzE6ZDQ0MDo%3D&cs=2&ds=4&ft=iueGFy7oZZv0PD1MuK2xg9wEYQmYkEeC~&mime_type=video_mp4&qs=15&rc=OjM6NTpoZmc3aTU1O2c6aEBpM2V3ZW85cjhrbzMzZjczM0BfNTE0NWM2NTIxXmFgNjNhYSNlMmkxMmQ0cm9gLS1kMWNzcw%3D%3D&l=202312120146340B58A398BD8AA512D3F9&btag=e00088000&cc=24>
</td>
<td style="text-align:left;">
\#BMWi7 , \#carsoftiktok , \#ThisIsForwardism, \#bmwlove , \#fy , \#BMW
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
bmw
</td>
<td style="text-align:left;">
7310236136138476832
</td>
<td style="text-align:left;">
<https://www.tiktok.com/@6811960716250203142/video/7310236136138476832>
</td>
<td style="text-align:left;">
2023-12-08 14:49:51
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
A NEUE vision is in sight 💛 100% Electric.  \#THEVisionNeueKlasse
\#TheNeueNew \#bmwlive \#FutureMobility \#fy
</td>
<td style="text-align:right;">
67262
</td>
<td style="text-align:right;">
5514
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
171
</td>
<td style="text-align:left;">
Lofuu & Shiloh Dynasty & dprk
</td>
<td style="text-align:left;">
love song (hesitations) (sped up)
</td>
<td style="text-align:left;">
<https://v19-us.tiktokcdn.com/34927f23b8d3090dfba279d16f5eaf2e/65780fe4/video/tos/useast2a/tos-useast2a-ve-0068-euttp/oglheLGTjIGM4I9VemIQYoEAWHegtsHB5KegS7/?a=1180&ch=0&cr=13&dr=0&lr=all&cd=0%7C0%7C0%7C&cv=1&br=574&bt=287&bti=OHYpOTY0Zik3OjlmOm01MzE6ZDQ0MDo%3D&cs=2&ds=4&ft=iueGFy7oZZv0PD1XuK2xg9wEYQmYkEeC~&mime_type=video_mp4&qs=15&rc=O2Q2OzVkNWc6OWU7ZDlpOEBpMzw0OHU5cjVsbzMzZjczM0AuLTM2XzMwNjUxNDMxX2AvYSM1cmQxMmRrbm1gLS1kMWNzcw%3D%3D&l=20231212014636B4BF297CC7517B13D88D&btag=e00088000&cc=25>
</td>
<td style="text-align:left;">
\#THEVisionNeueKlasse, \#TheNeueNew , \#bmwlive , \#FutureMobility ,
\#fy
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
bmw
</td>
<td style="text-align:left;">
7309517155312094497
</td>
<td style="text-align:left;">
<https://www.tiktok.com/@6811960716250203142/video/7309517155312094497>
</td>
<td style="text-align:left;">
2023-12-06 16:19:49
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:left;">
The perfect way to unwind 🧘 \#BMWRepost (IG: mr.sharknose) \#BMWlove
\#carsoftiktok \#BMWClassic \#BMW \#fy
</td>
<td style="text-align:right;">
52585
</td>
<td style="text-align:right;">
3470
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:left;">
lolayounggg
</td>
<td style="text-align:left;">
Conceited
</td>
<td style="text-align:left;">
<https://v19-us.tiktokcdn.com/ff32fe6fda4a8d907d3a8a159275063e/65780ff2/video/tos/useast2a/tos-useast2a-ve-0068c001-euttp/o87CENyDdB1wSAC49IqwvWIQiBXiZEn6T0CNq/?a=1180&ch=0&cr=13&dr=0&lr=all&cd=0%7C0%7C0%7C&cv=1&br=2376&bt=1188&bti=OHYpOTY0Zik3OjlmOm01MzE6ZDQ0MDo%3D&cs=2&ds=4&ft=iueGFy7oZZv0PD1w0K2xg9wEYQmYkEeC~&mime_type=video_mp4&qs=15&rc=aTwzPDw3aDM3O2hkaDQ7M0BpajYzZHI5cnQ8bzMzZjczM0BjLS02Xi5gNjQxYTZhM141YSNubmUuMmRrb2xgLS1kMWNzcw%3D%3D&l=20231212014638FD544B02417B05136C82&btag=e00088000&cc=25>
</td>
<td style="text-align:left;">
\#BMWRepost , \#BMWlove , \#carsoftiktok, \#BMWClassic , \#BMW , \#fy
</td>
<td style="text-align:left;">
</td>
</tr>
</tbody>
</table>
