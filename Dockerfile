FROM n8nio/n8n:latest-debian

USER root

# Dépendances système requises par Playwright
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
 && rm -rf /var/lib/apt/lists/*

# Installer LangChain (global, pour Function / Code nodes)
RUN npm install -g \
    langchain@0.3.3 \
    @langchain/core@0.3.8 \
    @langchain/openai@0.3.4

# Installer le node n8n Playwright
RUN mkdir -p /home/node/.n8n \
 && cd /home/node/.n8n \
 && npm init -y \
 && npm install n8n-nodes-playwright

# Installer Chromium via Playwright (OFFICIEL, supporté)
RUN cd /home/node/.n8n/node_modules/n8n-nodes-playwright \
 && npx playwright install chromium

# Permissions
RUN chown -R node:node /home/node/.n8n \
 && chown -R node:node /usr/local/lib/node_modules

ENV NODE_PATH=/usr/local/lib/node_modules

USER node
