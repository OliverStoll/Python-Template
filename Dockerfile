FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y gcc  # for poetry
RUN pip install poetry
RUN poetry install --only main
CMD ["poetry", "run", "python", "./src/basic.py"]
