FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY app.py .

EXPOSE 8501

EXPOSE 8502

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.port=8502", "--server.address=0.0.0.0"]