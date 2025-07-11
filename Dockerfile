FROM ollama/ollama:0.7.0

ENV API_BASE_URL=http://127.0.0.1:11434/api
ENV MODEL_NAME_AT_ENDPOINT=qwen2.5:1.5b

# Install Node.js and pnpm
RUN apt-get update && apt-get install -y \
  curl \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g pnpm

WORKDIR /app

# Only copy files if they exist
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY .env.docker ./

RUN pnpm install

COPY . .

RUN pnpm run build

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["ollama serve & sleep 5 && ollama pull ${MODEL_NAME_AT_ENDPOINT} && node .mastra/output/index.mjs"]

