FROM docker.n8n.io/n8nio/n8n:stable

USER root

# Mets à jour npm pour éviter les warnings moisis
RUN npm install -g npm@latest \
    && npm install -g langchain @langchain/core

USER node
