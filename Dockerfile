FROM python:3.11
ENV PYTHONUNBUFFERED True

RUN apt-get update
RUN apt-get install -y gcc python3-dev

RUN pip install pipenv

ENV PORT 8080
CMD exec mlflow server --host 0.0.0.0 --port ${PORT}