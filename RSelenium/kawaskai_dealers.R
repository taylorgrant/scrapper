# Scraping Kawasaki Dealers in NAV States #
# Have to use RSelenium to do this # 

# states - California, Arizona, Texas, Florida, Georgia, North Carolina, South Carolina
pacman::p_load(tidyverse, janitor, here, glue, RSelenium)

# load zip code data for states
zips <- readxl::read_excel("~/R/kawasaki/nav/data/ZIP Code ZCTA Crosswalk 2022.xlsx") |> 
  clean_names()

zips |> filter(state %in% c("CA", "AZ", "TX", "FL", "GA", "NC", "SC") & zip_type == "Zip Code Area")
ca_zips <- zips |> 
  filter(state == "CA" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

az_zips <- zips |> 
  filter(state == "AZ" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

tx_zips <- zips |> 
  filter(state == "AZ" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

fl_zips <- zips |> 
  filter(state == "FL" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

ga_zips <- zips |> 
  filter(state == "GA" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

nc_zips <- zips |> 
  filter(state == "NC" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()

sc_zips <- zips |> 
  filter(state == "SC" & zip_type == "Zip Code Area") |> 
  distinct(zip_code) |> 
  pull()



# Instantiate Selenium Server ---------------------------------------------
# start a session
rD <- rsDriver(browser = "firefox", port = 4545L, verbose = FALSE)
remDr <- rD$client

# Zip code list
zip_codes <- ca_zips # Add more zip codes as needed

# Initialize an empty tibble to store results
dealer_data <- NULL

dealer_data <- map_dfr(zip_codes, function(zip) {
  # Open the dealer locator page
  remDr$navigate("https://www.kawasaki.com/en-us/research-tools/dealer-locator")
  Sys.sleep(2) # Wait for the page to load
  
  # Enter the zip code
  zip_input <- remDr$findElement(using = "css", "#dealerSearchInput")
  zip_input$clearElement() # Clear any pre-filled text
  zip_input$sendKeysToElement(list(as.character(zip)))
  
  # Click the search button
  search_button <- remDr$findElement(using = "css", "#dealerSearchBtn")
  search_button$clickElement()
  
  Sys.sleep(3) # Wait for results to load
  
  # Extract dealer information
  dealers <- remDr$findElements(using = "css", "#dealerSearchResults > li") # Get all dealer result items
  
  if (length(dealers) == 0) {
    # No dealers found, return a single row tibble with NA values
    message(glue("No dealerships found for zip code: {zip}"))
    return(tibble(
      ZipCode = zip,
      Name = NA_character_,
      AddressLine1 = NA_character_,
      AddressLine2 = NA_character_,
      Phone = NA_character_
    ))
  } else {
    # Map over each dealer element to extract data
    map_dfr(dealers, function(dealer) {
      # Extract dealer details
      name <- dealer$findChildElement(using = "css", "a > h2")$getElementText() |> 
        unlist()
      address_line1 <- dealer$findChildElement(using = "css", "a > p:nth-child(2)")$getElementText() |> 
        unlist()
      address_line2 <- tryCatch(
        dealer$findChildElement(using = "css", "a > p:nth-child(3)")$getElementText() |> unlist(),
        error = function(e) NA_character_
      )
      phone <- tryCatch(
        dealer$findChildElement(using = "css", "a > p:nth-child(4)")$getElementText() |> unlist(),
        error = function(e) NA_character_
      )
      
      # Return a tibble for each dealer
      tibble(
        query_zip = zip,
        name = name,
        address_line1 = address_line1,
        address_line2 = address_line2,
        phone = phone
      )
    })
  }
})

# Close RSelenium session
remDr$close()
rD$server$stop()


# PUT ALL DATA INTO SINGLE FILE -------------------------------------------

data_path <- "~/R/kawasaki/nav/data/kawi_dealers"   # path to the data
files <- dir(data_path, pattern = "*.rds") # get file names

data <- files %>%
  map_dfr(~ readRDS(file.path(data_path, .)))

# crosswalk zipcode to DMA
gist <- "https://gist.github.com/clarkenheim/023882f8d77741f4d5347f80d95bc259/raw/f9f3424dbe4fb58b3dac65dced4c1c3a0f0db27a/Zip%2520Codes%2520to%2520DMAs"
dma_cross <- read.delim(gist, header = TRUE, sep = "\t")
# string pad the zips
dma_cross <- dma_cross |>
  mutate(zip_code = ifelse(nchar(zip_code) == 4,
                           str_pad(zip_code, 5, pad = "0"),
                           as.character(zip_code)))

clean_data <- data |> 
  clean_names() |> 
  mutate(city = gsub("\\,.*", "", address_line2),
         statezip = trimws(gsub(".*\\,", "", address_line2))) |> 
  separate(statezip, into = c("state", "zip"), sep = " ") |> 
  select(zip_query = zip_code, name, address = address_line1, city, state, zip, phone) |> 
  filter(!is.na(name))
  
clean_data |> 
  left_join(dma_cross, by = c("zip_query" = "zip_code")) |> 
  relocate(dma_code, .before = name) |> 
  relocate(dma_description, .before = name) |> 
  arrange(state, dma_description) |> 
  rename(query_dma = dma_description) |> 
  left_join(select(dma_cross, c(zip_code, dealer_dma = dma_description)), by = c("zip" = "zip_code")) |> 
  openxlsx::write.xlsx("~/R/kawasaki/nav/data/kawi_dealers/kawi_dealers_target_states.xlsx")




