import json
from final_project.DAO.narrative import narrative
from fastapi.responses import JSONResponse


async def get_narrative(description):
    description = json.dumps(description)
    response = narrative(description)

    return JSONResponse(content=json.loads(json.dumps(response)))
