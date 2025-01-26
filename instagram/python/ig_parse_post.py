import jmespath
from typing import Dict

def ig_parse_post(data: Dict) -> Dict:
    # print("parsing post data {}", data['xdt_shortcode_media'])
    result = jmespath.search("""{
        id: id,
        shortcode: shortcode,
        src: display_url,
        src_attached: edge_sidecar_to_children.edges[].node.display_url,
        has_audio: has_audio,
        video_url: video_url,
        views: video_view_count,
        plays: video_play_count,
        likes: edge_media_preview_like.count,
        comments: edge_media_to_parent_comment.count,
        location: location.name,
        taken_at: taken_at_timestamp,
        related: edge_web_media_to_related_media.edges[].node.shortcode,
        type: product_type,
        video_duration: video_duration,
        music: clips_music_attribution_info,
        is_video: is_video,
        tagged_users: edge_media_to_tagged_user.edges[].node.user.username,
        caption: edge_media_to_caption.edges[].node.text
    }""", data)
    return result
