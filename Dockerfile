FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd -m -r tooluser && \
    mkdir -p /app/tools /data && \
    chown -R tooluser:tooluser /app /data

WORKDIR /app

USER root
RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

USER tooluser
COPY --chown=tooluser:tooluser . .

EXPOSE 8000

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
