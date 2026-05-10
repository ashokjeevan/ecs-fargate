FROM python:3.9-slim

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]
