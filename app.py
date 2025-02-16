import streamlit as st
import openai
import google.generativeai as gemini
from groq import Groq
import os
from dotenv import load_dotenv
import requests as r
import json

# Load environment variables from .env file
load_dotenv()

# Set up API keys (replace with your keys)
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")

openai.api_key = OPENAI_API_KEY
gemini.configure(api_key=GEMINI_API_KEY)
Groq.api_key = GROQ_API_KEY

# Function to get AI response
def get_ai_response(prompt, model):
    """Function to get AI response from selected AI model."""
    try:
        if model == "ChatGPT":
            response = openai.ChatCompletion.create(
                model="gpt-4",  
                messages=[{"role": "user", "content": prompt}],
            )
            return response["choices"][0]["message"]["content"]
        elif model == "Gemini":
            response = gemini.generate_text(prompt)
            return response.result
        elif model == "Groq AI":
            client = Groq()
            print(client)
            headers = {
                "Authorization": f"Bearer {GROQ_API_KEY}",
                "Content-Type": "application/json",
            }
            payload = {
                "model": "mixtral-8x7b-32768",
                "messages": [{"role": "user", "content": prompt}],
                "max_tokens": 500,
            }
            response = r.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers=headers,
                data = json.dumps(payload)
            )
            print(response.json())
            if response.status_code != 200:
                return f"Error: {response.text}"
            else:
                return response.json()["choices"][0]["message"]["content"]

    except Exception as e:
        return f"Error: {str(e)}"

# Streamlit app UI
st.set_page_config(page_title="AI Chat Assistant", layout="centered")
st.title("🤖 AI Chat Assistant")
st.caption("Your personal AI assistant. Ask anything!")

# AI Model Selection
selected_model = st.selectbox("Choose AI Model:", ["ChatGPT", "Gemini", "Groq AI"])

# Initialize chat history
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display chat history with improved styling
st.markdown("---")
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(f"**{message['role'].capitalize()}**: {message['content']}")
        st.markdown("---")

# User input
user_input = st.chat_input("Type your message here...")


if user_input:
    # Append user message to chat history
    st.session_state.messages.append({"role": "user", "content": user_input})
    with st.chat_message("user"):
        st.markdown(f"**You:** {user_input}")
    
    # Get AI response with loading indicator
    with st.spinner("Thinking..."):
        response = get_ai_response(user_input, selected_model)
    
    st.session_state.messages.append({"role": "assistant", "content": response})
    with st.chat_message("assistant"):
        st.markdown(f"**{selected_model}:** {response}")
        st.markdown("---")

# Add a clear chat button with confirmation
if st.button("🗑️ Clear Chat"):
    # if st.confirm("Are you sure you want to clear the chat?"):
    st.session_state.messages = []
    st.rerun()

# Add a footer section
st.markdown("---")
st.markdown("*Powered by OpenAI, Gemini, and Groq AI | Built with Streamlit* 🚀")
