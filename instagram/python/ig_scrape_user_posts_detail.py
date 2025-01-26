import json
import httpx
from urllib.parse import quote
import time

INSTAGRAM_DOCUMENT_ID = "8845758582119845"  # For ig_scrape_post

# Function to scrape user posts and retrieve shortcodes
def ig_scrape_user_posts(user_id: str, session: httpx.Client, page_size=12, max_pages: int = None):
    base_url = "https://www.instagram.com/graphql/query/?query_hash=e769aa130647d2354c40ea6a439bfc08&variables="
    variables = {
        "id": user_id,
        "first": page_size,
        "after": None,
    }
    _page_number = 1
    shortcodes = []
    
    while True:
        resp = session.get(base_url + quote(json.dumps(variables)))
        data = resp.json()
        posts = data["data"]["user"]["edge_owner_to_timeline_media"]
        
        # Collect shortcodes
        shortcodes.extend([post["node"]["shortcode"] for post in posts["edges"]])
        
        page_info = posts["page_info"]
        if _page_number == 1:
            print(f"Scraping total {posts['count']} posts of user {user_id}")
        else:
            print(f"Scraping page {_page_number}")
        
        if not page_info["has_next_page"]:
            break
        if variables["after"] == page_info["end_cursor"]:
            break
        variables["after"] = page_info["end_cursor"]
        _page_number += 1
        
        if max_pages and _page_number > max_pages:
            break

    return shortcodes

# Function to scrape detailed data for a single post
def ig_scrape_post(shortcode: str, session: httpx.Client) -> dict:
    print(f"Scraping detailed data for post: {shortcode}")
    variables = quote(json.dumps({
        'shortcode': shortcode,
        'fetch_tagged_user_count': None,
        'hoisted_comment_id': None,
        'hoisted_reply_id': None,
    }, separators=(',', ':')))
    body = f"variables={variables}&doc_id={INSTAGRAM_DOCUMENT_ID}"
    url = "https://www.instagram.com/graphql/query"

    result = session.post(
        url=url,
        headers={"content-type": "application/x-www-form-urlencoded"},
        data=body
    )
    data = json.loads(result.content)
    return data["data"]["xdt_shortcode_media"]

# Combined Function: Fetch detailed data for all posts of a user
import pandas as pd
import time

def ig_scrape_user_posts_detail(user_id: str, session: httpx.Client, page_size=12, max_pages: int = None, sleep_time: float = 2.0):
    """
    Fetch detailed post data for all posts of a user and store each parsed result in a single row in a DataFrame.
    
    Args:
        user_id (str): The Instagram user ID.
        session (httpx.Client): An HTTPX session object.
        page_size (int): Number of posts per page.
        max_pages (int): Maximum number of pages to scrape.
        sleep_time (float): Time in seconds to wait between each post request (default: 2.0 seconds).
    
    Returns:
        pd.DataFrame: A DataFrame where each row corresponds to parsed post data.
    """
    # Step 1: Get shortcodes
    shortcodes = ig_scrape_user_posts(user_id, session, page_size, max_pages)
    
    # Step 2: Initialize an empty list to store parsed posts
    parsed_posts = []  # Ensure this is initialized
    
    for shortcode in shortcodes:
        try:
            # Fetch raw post data
            raw_post = ig_scrape_post(shortcode, session)
            # Parse the post data
            parsed_post = ig_parse_post(raw_post)
            # Append the parsed post to the list
            parsed_posts.append(parsed_post)
            print(f"Successfully parsed post: {shortcode}")
            
            # Sleep between requests
            time.sleep(sleep_time)
        except Exception as e:
            print(f"Failed to fetch or parse details for shortcode {shortcode}: {e}")
    
    # Step 3: Convert the list of parsed posts into a DataFrame
    if parsed_posts:  # Check if there are parsed posts to avoid empty DataFrame issues
        df = pd.DataFrame(parsed_posts)
    else:
        df = pd.DataFrame()  # Return an empty DataFrame if no posts were parsed
    
    return df


# Example Run
# if __name__ == "__main__":
#     with httpx.Client(timeout=httpx.Timeout(20.0)) as session:
#         user_id = "1067259270"  # Replace with the desired user ID
#         posts = scrape_user_post_details(user_id, session, max_pages=3)  # Fetch data for a limited number of pages
#         print(json.dumps(posts, indent=2, ensure_ascii=False))
