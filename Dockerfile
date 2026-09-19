FROM openjdk:17-jre-slim

RUN apt-get update && apt-get install -y python3 python3-pip ffmpeg && \
    pip3 install --no-cache-dir yt-dlp && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/lavalink/plugins && \
    wget -qO /opt/lavalink/Lavalink.jar https://github.com/lavalink-devs/Lavalink/releases/download/4.0.8/Lavalink.jar && \
    wget -qO /opt/lavalink/plugins/lavasrc-plugin.jar https://maven.topi.wtf/releases/com/github/topi314/lavasrc/lavasrc-plugin/4.0.0/lavasrc-plugin-4.0.0.jar

RUN cat > /opt/lavalink/application.yml << 'EOYAML'
server:
  port: 2333
  address: 0.0.0.0

lavalink:
  server:
    password: "https://seretia.link/discord"
    sources:
      youtube: true
      bandcamp: true
      soundcloud: true
      twitch: true
      vimeo: true
      http: true
      local: true
  plugins:
    - dependency: "com.github.topi314.lavasrc:lavasrc-plugin:4.0.0"
      repository: "https://maven.topi.wtf/releases"
  lavasrc:
    providers:
      - "ytsearch:\"%ISRC%\""
      - "ytsearch:%QUERY%"
    sources:
      youtube: true
      ytdlp: true
    ytdlp:
      enabled: true
      path: "yt-dlp"
      searchLimit: 10
    spotify:
      clientId: "5b41bb9da40043db9349f86bacd59a19"
      clientSecret: "c43771ad7dba4ae89512c51c6931c8a4"
      countryCode: "US"
EOYAML

EXPOSE 2333
CMD ["java", "-jar", "/opt/lavalink/Lavalink.jar"]