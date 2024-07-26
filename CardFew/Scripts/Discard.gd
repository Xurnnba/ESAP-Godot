extends Node

var discardContents = []

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func discardCards(cardNames):
	for cardName in cardNames:
		discardContents.append(cardName)

func returnCards(cardNames):
	for cardName in cardNames:
		discardContents.remove_at(discardContents.find(cardName))

func randomCard():
	if discardContents.size() > 0:
		return discardContents[rng.randi_range(0, discardContents.size()-1)]
	return null

func clearCards():
	discardContents = []
