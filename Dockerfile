FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV SERVER_HOST=0.0.0.0
ENV SERVER_PORT=8000

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# 兼容 requirements.txt 被写成单行空格分隔的情况
RUN python -m pip install --upgrade pip \
    && (pip install --no-cache-dir -r requirements.txt \
        || (tr ' ' '\n' < requirements.txt > /tmp/requirements.txt \
            && pip install --no-cache-dir -r /tmp/requirements.txt))

COPY . .

RUN mkdir -p /app/logs /app/users

EXPOSE 8000

CMD ["python", "main.py"]
