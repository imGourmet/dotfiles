#!/usr/bin/env python3
import feedparser

rss_urls = [
    "https://feeds.megaphone.fm/GLT1412515089"
]

num_episodes = 2

playlist = """<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
  <trackList>
"""

for rss_url in rss_urls:

    feed = feedparser.parse(rss_url)
    

    latest_episodes = feed.entries[:num_episodes]
    

    for episode in latest_episodes:
        playlist += f"""
        <track>
          <location>{episode.enclosures[0].href}</location>
          <title>{episode.title}</title>
        </track>
        """


playlist += """
  </trackList>
</playlist>
"""

with open("/home/andrew/vlc/podcasts/latest_episodes.xspf", "w") as file:
    file.write(playlist)

print("Playlist generated: latest_episodes.xspf")
