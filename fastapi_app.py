from fastapi import FastAPI
from fastapi.middleware.wsgi import WSGIMiddleware
from mlflow.server import app as mlflow_app

app = FastAPI()
app.mount("/", WSGIMiddleware(mlflow_app))
