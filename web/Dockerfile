# ========================
# Base commune
# ========================
FROM python:3.13-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Installer les dépendances système
# RUN apt-get update && apt-get install -y --upgrade --no-install-recommends \
#     libpq-dev \
#     libglib2.0-0 \
#     libglib2.0-dev \
#     libcairo2 \
#     libpango-1.0-0 \
#     libpangocairo-1.0-0 \
#     libgdk-pixbuf-2.0-0 \
#     libffi-dev \
#     shared-mime-info \
#     && rm -rf /var/lib/apt/lists/*

# ========================
# Builder
# ========================
FROM base AS builder
WORKDIR /app
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .

# Installer les dépendances de build
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get remove -y gcc python3-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# ========================
# Image finale pour web
# ========================
FROM base AS web_image
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY . .
