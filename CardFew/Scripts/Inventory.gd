extends Node

var inventory = ["Blue Eyes"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addCards(cardNames):
	for cardName in cardNames:
		inventory.append(cardName)

func removeCard(cardName):
	inventory.remove_at(inventory.find(cardName))
