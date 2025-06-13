FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Aktualisiere Paketlisten und installiere LÖVE
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends love \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Optional: Installiere weitere Tools für die Spieleentwicklung
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
       zip \
       unzip \
       luarocks \
       vim \
       htop \
       curl \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Optional: Installiere nützliche Lua-Pakete mit luarocks
RUN luarocks install luacheck
RUN luarocks install busted
