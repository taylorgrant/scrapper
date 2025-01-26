import httpx
import json
from urllib.parse import quote

def ig_fetch_comments(shortcode, session, first=50):
    """
    Fetch all comments for a post using Instagram's GraphQL API.
    
    Args:
        shortcode (str): The shortcode of the Instagram post.
        session (httpx.Client): HTTPX session for making requests.
        first (int): Number of comments to fetch per page (default: 50).
    
    Returns:
        list: A list of all comments for the post.
    """
    base_url = "https://www.instagram.com/graphql/query/"
    query_hash = "bc3296d1ce80a24b1b6e40b1e72903f5"  # Query hash for fetching comments
    variables = {
        "shortcode": shortcode,
        "first": first,
        "after": None  # Cursor for pagination
    }

    all_comments = []
    
    while True:
        # Encode variables as a JSON string
        variables_str = quote(json.dumps(variables, separators=(",", ":")))
        url = f"{base_url}?query_hash={query_hash}&variables={variables_str}"
        
        # Fetch the data
        response = session.get(url)
        data = response.json()
        
        # Extract comments and page info
        edges = data["data"]["shortcode_media"]["edge_media_to_parent_comment"]["edges"]
        page_info = data["data"]["shortcode_media"]["edge_media_to_parent_comment"]["page_info"]
        
        # Append comments to the list
        for edge in edges:
            comment_node = edge["node"]
            all_comments.append({
                "id": comment_node["id"],
                "text": comment_node["text"],
                "created_at": comment_node["created_at"],
                "username": comment_node["owner"]["username"],
                "is_verified": comment_node["owner"]["is_verified"],
                "likes": comment_node["edge_liked_by"]["count"]
            })
        
        # Check if there's a next page
        if not page_info["has_next_page"]:
            break
        
        # Update the cursor for the next page
        variables["after"] = page_info["end_cursor"]
    
    return all_comments

# Example usage
# if __name__ == "__main__":
#     with httpx.Client(timeout=30) as session:
#         shortcode = "DE5HUT1oKn-"  # Replace with the shortcode of the post
#         comments = fetch_comments(shortcode, session, first=50)
#         print(json.dumps(comments, indent=2))
