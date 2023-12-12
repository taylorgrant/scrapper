# Tiktok Trending Hashtag Data #
pacman::p_load(tidyverse, corrr, shiny, shinythemes, shinyWidgets, shinyBS, shinyjs, DT, echarts4r)

ui <- fluidPage(
  navbarPage(theme = shinytheme("flatly"), collapsible = FALSE,
             
             title = tagList(
               actionLink("sidebar_button","",icon = icon("bars")
               ), "TikTok"
             ),
             
             tags$head(
               tags$style(
                 HTML(".shiny-output-error-validation {color: #464646; font-size: 120%;font-weight:bold;},
                               #download {width: 150px;}")
               )
             ), 
             
             tabPanel("TikTok Hashtag Trends",
                      tags$head(
                        tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
                      ),
                      shiny::sidebarLayout(
                        shiny::sidebarPanel(
                          span(
                            tags$i(
                              h5("Enter a hashtag of interest...")
                            ), 
                            style="color:#045a8d"
                          ),
                          shiny::textInput(
                            "tt_hash", 
                            label = "", 
                            value = ""),
                          actionButton(
                            "run_url", 
                            "Get Data",
                            icon = icon("person-running"),
                            width = "150px"
                          ), 
                          br(),
                          br(),
                          uiOutput('reset'),
                          br(),
                          uiOutput('download')
                        ),
                        
                        shiny::mainPanel(
                          shiny::fluidRow(
                            shiny::column(
                              width = 12,
                              style = 'background-color:#ededed;border-top-left-radius:10px !important;border-top-right-radius:10px !important;',
                              htmlOutput("text_hashtag")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 3, 
                              style='background-color:#ededed;border-bottom-left-radius:10px !important;',
                              htmlOutput("text_left_post")
                            ),
                            shiny::column(
                              width = 3, 
                              style='background-color:#ededed;',
                              htmlOutput("text_right_post")
                              
                            ),
                            shiny::column(
                              width = 3, 
                              style='background-color:#ededed;',
                              htmlOutput("text_left_video")
                              
                            ),
                            shiny::column(
                              width = 3, 
                              style='background-color:#ededed;border-bottom-right-radius:10px !important;',
                              htmlOutput("text_right_video")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 4, 
                              htmlOutput("index_title")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 12, 
                              offset = 0,
                              echarts4rOutput("hashtag_plot") |> 
                                shinycssloaders::withSpinner(
                                  type = 3, 
                                  color="#29C1A2",
                                  color.background = "white"
                                )
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 4,
                              htmlOutput("audience_title")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 6,
                              echarts4rOutput("demo_plot")
                            ),
                            shiny::fluidRow(
                              shiny::column(
                                width = 6, 
                                DT::DTOutput("interest_tbl")
                              )
                            )
                          ),  
                          shiny::fluidRow(
                            shiny::column(
                              width = 4, 
                              htmlOutput("related_title")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 12,
                              DT::DTOutput("related_kw_tbl")
                            )
                          ),  
                          br(),
                          shiny::fluidRow(
                            shiny::column(
                              width = 4,
                              echarts4rOutput("main_kw_p") 
                            ),
                            shiny::column(
                              width = 4,
                              echarts4rOutput("related_kw_p1")
                            ),
                            shiny::column(
                              width = 4,
                              echarts4rOutput("related_kw_p2")
                            )
                          ),
                          br(),
                          shiny::fluidRow(
                            shiny::column(
                              width = 4,
                              echarts4rOutput("related_kw_p3") 
                            ),
                            shiny::column(
                              width = 4,
                              echarts4rOutput("related_kw_p4")
                            ),
                            shiny::column(
                              width = 4,
                              echarts4rOutput("related_kw_p5")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 4, 
                              htmlOutput("corr_title")
                            )
                          ),
                          shiny::fluidRow(
                            shiny::column(
                              width = 12,
                              DT::DTOutput("correlation_tbl") 
                            )
                          ),
                          br(),
                        )
                      )
             )
  )
)

server <- function(input, output) {
  
  # GET DATA FOR APP --------------------------------------------------------
  data <- shiny::eventReactive(input$run_url, {
    # load function
    source("/srv/shiny-server/hashtag-trends/R/tt_hashtag_data.R")
    # run function
    out <- tt_hashtag_data(input$tt_hash)
  })
  
  
  # UPPER INFOBOX -----------------------------------------------------------
  output$text_hashtag <- renderUI({
    req(input$run_url, data())
    HTML(paste0("<h2>#", input$tt_hash, "</h2>"))
  })
  
  output$text_left_post <- renderUI({
    req(input$run_url, data())
    l1 <- "<br><h4><strong>Posts</strong></h4>"
    l2 <- paste0("<h2>", scales::label_number(accuracy=.1, scale_cut=scales::cut_short_scale())(data()$post_count_last_3yrs), "</h2>")
    l3 <- "<h6>Last 3 years, United States</h6>"
    l4 <- "<br><h4></h4>"
    post <- paste(l1, l2, l3, l4)
    tagList(
      HTML(post),
      bsTooltip("text_left_post", 
                title = scales::comma(data()$post_count_last_3yrs), 
                trigger = "hover",
                placement="bottom"
      )
    )
  })
  output$text_right_post <- renderUI({
    req(input$run_url, data())
    l1 <- "<br><h4></h4>"
    l2 <- paste0("<br><h2>", "/&emsp;&emsp;&emsp;", scales::label_number(accuracy= .1, scale_cut=scales::cut_short_scale())(data()$total_post_count), "</h2>")
    l3 <- "<h6>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;Overall</h6>"
    l4 <- "<br><h4></h4>"
    post <- paste(l1, l2, l3, l4)
    tagList(
      HTML(post),
      bsTooltip("text_right_post", 
                title = scales::comma(data()$total_post_count), 
                trigger = "hover",
                placement="bottom"
      )
    )
  })
  
  output$text_left_video <- renderUI({
    req(input$run_url, data())
    l1 <- "<br><h4><strong>Views</strong></h4>"
    l2 <- paste0("<h2>", scales::label_number(accuracy=.1, scale_cut=scales::cut_short_scale())(data()$video_views_last_3yrs),"</h2>")
    l3 <- "<h6>Last 3 years, United States</h6>"
    l4 <- "<br><h4></h4>"
    post <- paste(l1, l2, l3, l4)
    tagList(
      HTML(post),
      bsTooltip("text_left_video", 
                title = scales::comma(data()$video_views_last_3yrs), 
                trigger = "hover",
                placement="bottom"
      )
    )
  })
  output$text_right_video <- renderUI({
    req(input$run_url, data())
    l1 <- "<br><h4></h4>"
    l2 <- paste0("<br><h2>", "/&emsp;&emsp;&emsp;", scales::label_number(accuracy=.1, scale_cut=scales::cut_short_scale())(data()$total_video_views),"</h2>")
    l3 <- "<h6>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;Overall</h6>"
    l4 <- "<br><h4></h4>"
    post <- paste(l1, l2, l3, l4)
    tagList(
      HTML(post),
      bsTooltip("text_right_video", 
                title = scales::comma(data()$total_video_views), 
                trigger = "hover",
                placement="bottom"
      )
    )
  })
  
  
  # SECTION HEADERS ---------------------------------------------------------
  output$index_title <- renderUI({
    req(input$run_url, data())
    HTML('<h4>Popularity over time</h4>')
  })
  output$audience_title <- renderUI({
    req(input$run_url, data())
    HTML('<h4>Audience insights</h4>')
  })
  output$related_title <- renderUI({
    req(input$run_url, data())
    HTML('<h4>Related keywords</h4>')
  })
  output$corr_title <- renderUI({
    req(input$run_url, data())
    HTML('<h4>Hashtag correlations</h4>')
  })
  
  # APP PLOTS ---------------------------------------------------------------
  output$hashtag_plot <-  renderEcharts4r({
    data()$trend |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#",input$tt_hash), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading()  |> 
      e_color("#ee1d52") |> 
      e_theme("dark")
  })
  
  output$demo_plot <-  renderEcharts4r({
    data()$audience_ages |> 
      e_charts(ageLevel) |> 
      e_pie(score, radius = c("50%", "70%")) |> 
      e_title(paste0("#", input$tt_hash, ": Audience by Age")) |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_color(c("#FF315D", "#0CEEE4", "#0175FF")) |> 
      e_tooltip(formatter = htmlwidgets::JS("
                                        function(params){
                                        return('<strong>' + params.name + 
                                        ':</strong> ' + params.percent)  +'%' }  ")) |> 
      e_show_loading() 
    
  })
  
  output$main_kw_p <- renderEcharts4r({
    data()$trend |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", input$tt_hash), "Monthly Popularity, US") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |> 
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  output$related_kw_p1 <-  renderEcharts4r({
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$related_trends |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1,
             hashtag == data()$related_hashtags[1]) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", data()$related_hashtags[1]), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |> 
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  output$related_kw_p2 <-  renderEcharts4r({
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$related_trends |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1,
             hashtag == data()$related_hashtags[2]) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", data()$related_hashtags[2]), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |> 
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  output$related_kw_p3 <-  renderEcharts4r({
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$related_trends |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1,
             hashtag == data()$related_hashtags[3]) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", data()$related_hashtags[3]), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |> 
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  output$related_kw_p4 <-  renderEcharts4r({
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$related_trends |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1,
             hashtag == data()$related_hashtags[4]) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", data()$related_hashtags[4]), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |> 
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  output$related_kw_p5 <-  renderEcharts4r({
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$related_trends |> 
      filter(time != lubridate::ceiling_date(Sys.Date(), "month") -1,
             hashtag == data()$related_hashtags[5]) |> 
      rename(Index = value) |> 
      e_charts(time) |> 
      e_area(Index) |> 
      e_title(paste0("#", data()$related_hashtags[5]), "Monthly Popularity") |> 
      e_legend(FALSE) |> 
      e_tooltip(trigger = "axis") |> 
      e_show_loading() |>
      e_color("#00f2ea") |> 
      e_theme("dark")
  })
  
  
  # DATA TABLES -------------------------------------------------------------
  output$interest_tbl <- DT::renderDT({
    req(input$run_url, data())
    validate(
      need(nrow(data()$audience_interests) > 0, "There are no related interests associated with this hashtag")
    )
    data()$audience_interests |> 
      rename(Interest = interest, 
             Index = score) |> 
      DT::datatable(
        rownames = FALSE,
        class = c("stripe", "hover"),
        options = list(
          columnDefs = list(
          ),
          dom = "t"
        ),
        caption = htmltools::tags$caption("Related Interets", style="color:#464646;font-size:18px;font-weight:bold;")
      )
  })
  
  output$related_kw_tbl <- DT::renderDT({
    req(input$run_url, data())
    data()$related_stats |> 
      DT::datatable(
        rownames = FALSE,
        colnames = c("Hashtag", "Posts (3 years)", "Posts (Total)", 
                     "Video Views (3 years)", "Video Views (Total)"), 
        class = c("stripe", "hover"),
        options = list(
          columnDefs = list(
          ),
          dom = "t"
        ),
        caption = htmltools::tags$caption("Stats", style="color:#464646;font-size:18px;font-weight:bold;")
      ) |> 
      formatCurrency(2:5,currency = "", interval = 3, digits = 0, mark = ",")
  })
  
  output$correlation_tbl <- DT::renderDT({
    req(input$run_url, data())
    validate(
      need(nrow(data()$related_trends) > 0, "No related keywords")
    )
    data()$trend |> 
      mutate(hashtag = input$tt_hash) |> 
      rbind(data()$related_trends) |> 
      pivot_wider(names_from = hashtag,
                  values_from = value) |> 
      select(-time) |> 
      corrr::correlate() |> 
      corrr::shave() |>
      rename(hashtag = term) |> 
      DT::datatable(
        rownames = FALSE,
        class = c("stripe", "hover"),
        options = list(
          columnDefs = list(
          ),
          dom = "t"
        )
      ) |> 
      formatRound(columns=2:6, digits=2)
  })
  
  
  # RESET ------------------------------------------------------------------
  output$reset <- renderUI({
    req(input$run_url, data())
    actionButton('reset', "RESET", width = "150px",
                 icon = icon('power-off'))
  })
  observeEvent(input$reset, {
    session$reload()
  })
  
  # DOWNLOAD ----------------------------------------------------------------
  output$download <- renderUI({
    req(input$run_url, data())
    shiny::downloadButton("downloadData", "Download Data")
  })  
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("#", input$tt_hash, "-Data-", Sys.Date(), ".xlsx", sep="")
    },
    content = function(file) {
      openxlsx::write.xlsx(data(), file)
    }
  )
}

shinyApp(ui, server)

