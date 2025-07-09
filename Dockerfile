FROM node:22-slim

# 安装 Puppeteer 所需依赖和 Chrome
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates fonts-liberation libappindicator3-1 libasound2 \
    libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 \
    libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 \
    xdg-utils libgbm-dev libxshmfence-dev libu2f-udev curl && \
    rm -rf /var/lib/apt/lists/*

# 安装 Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# 设置 Puppeteer 使用的 Chrome 路径
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome

# 安装项目依赖
WORKDIR /app
COPY . .
RUN npm install && npm run build

# 启动服务
CMD ["npm", "start"]
