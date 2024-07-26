from final_project.DAO.speech import speech
from fastapi.responses import JSONResponse
import json


async def get_speech(content):
    content = json.dumps(content)
    content = json.loads(content)
    return JSONResponse(content=json.loads(json.dumps(speech(content['description']))))
