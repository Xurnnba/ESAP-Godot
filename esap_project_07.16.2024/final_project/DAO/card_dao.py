import json
from dataclasses import dataclass
from typing import Dict, Any


@dataclass
class CardDao:
    name: str
    health: int
    ATK: int
    attribute: str
    tribute_cost: str
    energy_cost: str

    def __str__(self) -> str:
        return (f"CardDAO(name={self.name}, health={self.health}, "
                f"ATK={self.ATK}, attribute={self.attribute},"
                f"tribute_cost={self.tribute_cost},energy_cost={self.energy_cost})")
