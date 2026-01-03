FROM docker.n8n.io/n8nio/n8n:stable
USER root

# Forcer Playwright à utiliser le cache standard (partagé)
ENV PLAYWRIGHT_BROWSERS_PATH=0

RUN npm install -g \
    playwright \
    langchain@0.3.3 \
    @langchain/core@0.3.8 \
    @langchain/openai@0.3.4 \
 && PLAYWRIGHT_SKIP_HOST_REQUIREMENTS=1 playwright install chromium \
 && npm cache clean --force \
 && chown -R node:node /usr/local/lib/node_modules \
 && chown -R node:node /home/node

ENV NODE_PATH=/usr/local/lib/node_modules

USER node
