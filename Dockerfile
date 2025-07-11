@@ -1,21 +1,26 @@
FROM ollama/ollama:0.7.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
# Qwen2.5:1.5b - Docker
ENV API_BASE_URL=http://127.0.0.1:11434/api
ENV MODEL_NAME_AT_ENDPOINT=qwen2.5:1.5b

# Install pnpm
RUN npm install -g pnpm
# Qwen2.5:32b = Docker
# ENV API_BASE_URL=http://127.0.0.1:11434/api
# ENV MODEL_NAME_AT_ENDPOINT=qwen2.5:32b

# Install Ollama
# RUN curl -fsSL https://ollama.com/install.sh | sh
# Install system dependencies and Node.js
RUN apt-get update && apt-get install -y \
  curl \
  && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g pnpm

# Create app directory
WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./
COPY .env.docker package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install
@@ -26,5 +31,8 @@ COPY . .
# Build the project
RUN pnpm run build

# Override the default entrypoint
ENTRYPOINT ["/bin/sh", "-c"]

# Start Ollama service and pull the model, then run the app
CMD ["/bin/sh", "-c", "ollama serve & sleep 5 && ollama pull qwen2.5:1.5b && node .mastra/output/index.mjs"]
CMD ["ollama serve & sleep 5 && ollama pull ${MODEL_NAME_AT_ENDPOINT} && node .mastra/output/index.mjs"]
