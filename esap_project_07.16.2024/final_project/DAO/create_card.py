import json
# from card_dao import CardDao


def card(name: str, health: int, ATK: int, attribute: str, tribute_cost: int, energy_cost: int):
    card_dict = {
        "name": name,
        "health": health,
        "ATK": ATK,
        "attribute": attribute,
        "tribute_cost": tribute_cost,
        "energy_cost": energy_cost
    }
    json_string = json.dumps(card_dict)
    x = json.loads(json_string)
    return x

# def card(CardDAO):
#     return return json.loads(f'{"name": {CardDao.name}, "health": {CardDao.health}, "ATK": {CardDao.ATK}, "attribute": {CardDao.attribute}, "tribute_cost": {CardDao.tribute_cost}, "energy_cost": {CardDao.energy_cost}}')
#
