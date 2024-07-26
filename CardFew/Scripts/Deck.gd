extends Node

#card tracking
var deckContents = []

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func startup():
	deckContents = get_parent().get_parent().get_node("DeckDB").deckContents.duplicate()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw(cardCount):
	var cardsDrawn = []
	for x in cardCount:
		if !deckContents.is_empty():
			var cardDrawn = rng.randf_range(0, deckContents.size())
			cardsDrawn.append(deckContents[cardDrawn])
			deckContents.remove_at(cardDrawn)
		else:
			get_parent().endGame(false)
	get_parent().get_node("PlayerHand").addCards(cardsDrawn)

func add(cardNames):
	for cardName in cardNames:
		deckContents.append(cardName)
