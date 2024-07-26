from fastapi import FastAPI, Body
from final_project.Service.get_card import get_card
import json
from final_project.Service.get_narrative import get_narrative
from final_project.Service.get_speech import get_speech

# test_json = json.dumps({
#   "name": "sample",
#   "id": "123",
#   "health": 10,
#   "ATK": 5,
#   "attribute": "sample"
# })

app = FastAPI()


@app.post("/card")
async def handle_request(description_json=Body(...)):
    # print(await get_card(description_json))
    return await get_card(description_json)


@app.post("/narrative")
async def handle_narrative(description_json=Body(...)):
    # print(await get_card(description_json))
    return await get_narrative(description_json)


@app.post("/speech")
async def handle_speech(speech=Body(...)):
    # print(await get_card(description_json))
    return await get_speech(speech)
