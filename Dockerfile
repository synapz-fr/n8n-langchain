FROM docker.n8nio.io/n8n:nightly-ec68851

USER root

# Mets à jour npm pour éviter les warnings moisis
RUN npm install -g npm@latest \
    && npm install -g langchain @langchain/core

USER node
