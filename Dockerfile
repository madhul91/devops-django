# # ---------- Stage 1: Builder ----------
# FROM python:3.9 AS builder

# WORKDIR /app

# RUN apt-get update && apt-get install -y \
#     gcc \
#     default-libmysqlclient-dev \
#     pkg-config \
#     && rm -rf /var/lib/apt/lists/*

# COPY requirements.txt .
# RUN pip install --user --no-cache-dir -r requirements.txt


# # ---------- Stage 2: Final ----------
# FROM python:3.9-slim

# WORKDIR /app

# # install curl for healthcheck
# RUN apt-get update && apt-get install -y curl \
#     && rm -rf /var/lib/apt/lists/*

# COPY --from=builder /root/.local /root/.local

# ENV PATH=/root/.local/bin:$PATH

# COPY . .



# EXPOSE 8000

# CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]


# ---------- Stage 1: Builder ----------
FROM python:3.9 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# ✅ FIX: remove --user
RUN pip install --no-cache-dir -r requirements.txt


# ---------- Stage 2: Final ----------
FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# ✅ copy global site-packages instead
COPY --from=builder /usr/local /usr/local

COPY . .

EXPOSE 8000

CMD ["gunicorn", "notesapp.wsgi:application", "--bind", "0.0.0.0:8000"]