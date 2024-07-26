import json
from dataclasses import dataclass
from typing import Dict, Any


@dataclass
class DescriptionDao:
    description: str

    def __str__(self) -> str:
        return f"DescriptionDAO(description={self.description})"
