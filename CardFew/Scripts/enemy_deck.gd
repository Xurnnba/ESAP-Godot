extends Node

#card tracking
var deckContents = ["Dummy", "Dummy", "Right Rabbit", "Wrong Rabbit", "Kuriboh", "Hawk", "Skeleton King"]
var enemyDeckDB = ["Dummy", "Dummy", "Right Rabbit", "Wrong Rabbit", "Kuriboh", "Hawk", "Skeleton King"]
var queuedDeck = []

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func startup():
	deckContents = enemyDeckDB.duplicate()
	if get_parent().get_parent().get_node("MainMenu").prizePool == [] && queuedDeck != []:
		enemyDeckDB = queuedDeck.duplicate()
		
		for card in ["Dummy", "Dummy", "Right Rabbit", "Wrong Rabbit", "Kuriboh", "Hawk", "Skeleton King"]:
			enemyDeckDB.append(card)
		
		deckContents = enemyDeckDB.duplicate()
		queuedDeck = []
		
	print(deckContents)

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
			pass
	get_parent().get_node("EnemyHand").addCards(cardsDrawn)

func add(cardName):
	deckContents.append(cardName)

func addToEnemyDeck(cardNames):
	for cardName in cardNames:
		deckContents.append(cardName)
		enemyDeckDB.append(cardName)

func queueEnemyCards(cardNames):
	for cardName in cardNames:
		queuedDeck.append(cardName)

