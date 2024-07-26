import json
from final_project.Service.json_to_object import json_to_object
from final_project.DAO.description_dao import DescriptionDao
from final_project.Service.info_handle import info_handle
from final_project.DAO.openai_interface import conversation
from final_project.Service.get_image import get_image
from fastapi.responses import JSONResponse


async def get_card(description_json):
    # convert the json description to a card object
    description_json = json.dumps(description_json)
    description_object = json_to_object(description_json, DescriptionDao)

    messages = info_handle(description_object.description)
    response = conversation(messages)
    # returns a list of json if multiple cards are generated

    # get names from the response to generate images
    names = [card['name'] for card in response]
    card_images = [await get_image(i) for i in names]
    for card, url in zip(response, card_images):
        card['image'] = url

    # convert the list to json
    card_array = json.dumps(response)

    return JSONResponse(content=json.loads(card_array))
