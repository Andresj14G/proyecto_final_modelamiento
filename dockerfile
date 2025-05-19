

FROM python:3.11-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends octave \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"


COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


COPY . .


EXPOSE 8000

CMD gunicorn  calculadora-consumo-combustible.backend.main:app --bind 0.0.0.0:$PORT