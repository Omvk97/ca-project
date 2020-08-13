FROM python:3.8-slim

WORKDIR /usr/src/app

COPY . .

RUN apt-get update && pip install -r requirements.txt

CMD python run.py
