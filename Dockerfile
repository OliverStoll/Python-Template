FROM python:3.11
WORKDIR /app
COPY pyproject.toml ./
RUN pip install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --only main
COPY . .

EXPOSE 8080
ENV IS_CLOUD=true
CMD ["python", "./src/cloud_entry.py"]