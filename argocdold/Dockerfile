FROM public.ecr.aws/docker/library/python:3.13-slim
WORKDIR /app
COPY requirements.txt .
RUN apt install -y pip --no-cache-dir
RUN pip install -r requirements.txt
COPY app.py .
