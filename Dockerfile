FROM python:3.11
ENV PYTHONUNBUFFERED True

RUN apt-get update
RUN apt-get install -y gcc python3-dev

WORKDIR /app
COPY . ./

RUN pip install pipenv
RUN pipenv install --deploy --system

EXPOSE 8080

ENTRYPOINT ["../bin/bash", "set_environment.sh"]