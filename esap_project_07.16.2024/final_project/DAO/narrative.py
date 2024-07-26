from dotenv import load_dotenv
from openai import OpenAI
import json


load_dotenv()

client = OpenAI()

message= [{"role": "system", "content":"You are a card game "
                                       "master who takes description of the "
                                       "card played and other game state and "
                                       "generate an engaging response according "
                                       "to the persona of a card game master. Only generate one sentence per request"}]


def narrative(description):
    message.append({"role": "user", "content": description})
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=message
    )
    message.append({"role": "assistant", "content": response.choices[0].message.content})
    return {"description": response.choices[0].message.content}
