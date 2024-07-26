import json
from dataclasses import dataclass
from typing import Dict, Any
from final_project.DAO.card_dao import CardDao


def json_to_object(json_str: str, cls: type) -> Any:
    """
    Convert a JSON string to an object of the specified class.
    """
    data = json.loads(json_str)
    return cls(**data)



# json_str = '{"name": "Mystic Ghost", "health": 50, "ATK": 10, "attribute": "Spirit", "tribute_cost": 2, "energy_cost": 3}'
# temp = json_to_object(json_str, CardDao)
# print(temp.name)







# json_str = '{"name": "Mystic Ghost", "health": 50, "ATK": 10, "attribute": "Spirit", "tribute_cost": 2, "energy_cost": 3}'
#
# try:
#     temp = json_to_object(json_str, CardDao)
#     print(temp.name)
#     print(temp)  # This will use the __str__ method
# except json.JSONDecodeError as e:
#     print(f"JSON Decode Error: {e}")
# except Exception as e:
#     print(f"Error: {e}")