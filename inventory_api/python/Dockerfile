FROM python:3.14-rc-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV VAULT_ADDR="https://vault.tchowdhury.org"

EXPOSE 5000

CMD ["python", "inv_api.py"]
