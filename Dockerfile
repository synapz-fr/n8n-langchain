# Base Debian explicite (PAS Alpine, PAS de tag ambigu)
FROM node:20-bookworm-slim

# -------------------------------
# Dépendances système Playwright
# -------------------------------
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    ca-certificates \
    fonts-liberation \
    wget \
    tini \
 && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Installer n8n
# -------------------------------
RUN npm install -g n8n

# -------------------------------
# Installer LangChain (global)
# -------------------------------
RUN npm install -g \
    langchain@0.3.3 \
    @langchain/core@0.3.8 \
    @langchain/openai@0.3.4

# -------------------------------
# Installer n8n-nodes-playwright
# SANS npm init, SANS package.json
# -------------------------------
RUN mkdir -p /home/node/.n8n/node_modules \
 && cd /home/node/.n8n/node_modules \
 && npm install n8n-nodes-playwright

# -------------------------------
# Installer Chromium via Playwright
# (OFFICIEL, supporté, Debian)
# -------------------------------
RUN cd /home/node/.n8n/node_modules/n8n-nodes-playwright \
 && npx playwright install chromium

# -------------------------------
# Permissions propres
# -------------------------------
RUN useradd -m node \
 && chown -R node:node /home/node \
 && chown -R node:node /usr/local/lib/node_modules

USER node

# Pour que n8n puisse require LangChain
ENV NODE_PATH=/usr/local/lib/node_modules

# -------------------------------
# Entrypoint n8n propre
# -------------------------------
ENTRYPOINT ["tini", "--"]
CMD ["n8n"]
