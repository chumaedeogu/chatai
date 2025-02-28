# Use the slim Python base image
FROM python:3.13-slim

# Set the working directory
WORKDIR /app

# Create a new user and give ownership of /app
RUN useradd -m -s /bin/bash dockeruser && chown -R dockeruser:dockeruser /app

# Switch to the new user
USER dockeruser

# Add ~/.local/bin to PATH
ENV PATH="/home/dockeruser/.local/bin:$PATH"

# Copy requirements file and install dependencies
COPY --chown=dockeruser:dockeruser requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt --no-cache-dir

# Copy application files
COPY --chown=dockeruser:dockeruser app.py .

# Expose required ports
EXPOSE 8501
EXPOSE 8502

# Run Streamlit app
ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
