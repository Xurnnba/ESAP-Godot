from pathlib import Path

from dotenv import load_dotenv
from openai import OpenAI
import json


load_dotenv()

client = OpenAI()


def speech(content):
    response = client.audio.speech.create(
        model="tts-1",
        voice="onyx",
        input=content,
    )
    response.stream_to_file("/Users/huangkangyi/Downloads/ESAP-Godot/CardFew/audio/speech.mp3")
    return {"code": "success"}
