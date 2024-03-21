FROM python:3.11
ENV DOCKER_WORKDIR="/app"
WORKDIR $DOCKER_WORKDIR
COPY pyproject.toml ./
RUN pip install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --with cloud --without dev
COPY . /app

EXPOSE 8080
CMD ["python", "./src/cloud_entry.py"]