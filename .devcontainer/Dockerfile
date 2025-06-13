FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Workaround für das Man-Page-Problem mit LÖVE
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Erstelle das Verzeichnis für die problematische Man-Page
    && mkdir -p /usr/share/man/man6 \
    && touch /usr/share/man/man6/love-11.5.6.gz \
    # Installiere LÖVE und grundlegende Pakete
    && apt-get -y install --no-install-recommends \
       love \
       luarocks \
    # Cleanup
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Installiere weitere Tools für die Spieleentwicklung
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
       zip \
       unzip \
       lua5.1 \
       liblua5.1-dev \
       vim \
       htop \
       curl \
       git \
       bash-completion \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Installiere nützliche Lua-Pakete mit luarocks
RUN luarocks install luacheck && \
    luarocks install busted && \
    luarocks install luacov && \
    luarocks install inspect

# Setze Umgebungsvariablen für LÖVE und Lua
ENV LUA_PATH="./?.lua;./?/init.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua"
ENV LUA_CPATH="./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so"
