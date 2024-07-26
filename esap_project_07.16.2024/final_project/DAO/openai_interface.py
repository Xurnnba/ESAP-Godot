from dotenv import load_dotenv
from openai import OpenAI
from final_project.DAO.create_card import card
import json
from final_project.DAO.card_dao import CardDao
from final_project.Service.json_to_object import json_to_object

load_dotenv()

client = OpenAI()


tools = [
    {
        "type": "function",
        "function": {
            "name": "card",
            "description": "generate a card with used parameters",
            "parameters": {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string",
                        "description": "Name of the card",
                    },
                    "health": {
                        "type": "number",
                        "description": "health value of the card",
                    },
                    "ATK": {
                        "type": "number",
                        "description": "attack value of the card",
                    },
                    "attribute": {
                        "type": "string",
                        "description": "the card's special attribute that affects the game",
                    },
                    "tribute_cost": {
                        "type": "number",
                        "description": "number of sacrifice of weaker cards to summon this powerful card ",
                    },
                    "energy_cost": {
                        "type": "number",
                        "description": "the number of energy needed for this card",
                    },
                },
                "required": ["name", "health", "ATK", "attribute", "energy_cost"],
            },
        },
    },
]


def conversation(messages):
    card_generated = []
    # print(messages)
    response = client.chat.completions.create(
        model="ft:gpt-3.5-turbo-0125:personal:exp07232024:9oGC9mhO",
        messages=messages,
        tools=tools,
        tool_choice="auto"
    )
    response_message = response.choices[0].message
    tool_calls = response_message.tool_calls

    if tool_calls:
        available_funcs = {"card": card}
        messages.append({"role": "assistant", "content": response.choices[0].message.content})

        for tool_call in tool_calls:
            function_name = tool_call.function.name
            function_to_call = available_funcs[function_name]
            function_args = json.loads(tool_call.function.arguments)
            # set up parameters for the function
            # convert the dictionary to a json string
            function_args = json.dumps(function_args)

            params = json_to_object(function_args, CardDao)
            function_response = function_to_call(params.name, params.health,
                                                 params.ATK, params.attribute,
                                                 params.tribute_cost, params.energy_cost)
            # append the card into an array
            card_generated.append(function_response)
            messages.append(
                {
                    "tool_call_id": tool_call.id,
                    "role": "tool",
                    "name": function_name,
                    "content": function_response,
                }
            )  # extend conversation with function response
        # second_response = client.chat.completions.create(
        #     model="gpt-4o-mini",
        #     messages=messages,
        # )  # get a new response from the model where it can see the function response
        return card_generated


def illustration(card_name):
    response = client.images.generate(
        model="dall-e-2",
        prompt=card_name,
        size="256x256",
        # quality="standard",
        style="natural",
        n=1,
    )
    image_url = response.data[0].url
    return image_url
