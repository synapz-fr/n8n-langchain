FROM node:20-bookworm-slim

# ---- Dépendances système Playwright (Debian sûr) ----
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

# ---- Installer n8n ----
RUN npm install -g n8n

# ---- Installer LangChain ----
RUN npm install -g \
    langchain@0.3.3 \
    @langchain/core@0.3.8 \
    @langchain/openai@0.3.4

# ---- Installer n8n-nodes-playwright ----
RUN mkdir -p /home/node/.n8n \
 && cd /home/node/.n8n \
 && npm init -y \
 && npm install n8n-nodes-playwright

# ---- Installer Chromium (Playwright OFFICIEL) ----
RUN cd /home/node/.n8n/node_modules/n8n-nodes-playwright \
 && npx playwright install chromium

# ---- Permissions ----
RUN useradd -m node \
 && chown -R node:node /home/node \
 && chown -R node:node /usr/local/lib/node_modules

USER node
ENV NODE_PATH=/usr/local/lib/node_modules

ENTRYPOINT ["tini", "--"]
CMD ["n8n"]
