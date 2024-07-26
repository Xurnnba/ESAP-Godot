extends Node2D

@export var cardUI: PackedScene

var cardList = []

var startX = 50
var endX = 670
var currX = startX
var xIncrement = 100

var startY = 100
var currY = startY
var yIncrement = 130

var DeckDB
var Inventory
var CardDB
var CardInfo

# Called when the node enters the scene tree for the first time.
func startup():
	#Defining all repeat-use node references
	DeckDB = get_parent().get_parent().get_node("DeckDB")
	Inventory = get_parent().get_parent().get_node("Inventory")
	CardDB = get_parent().get_parent().get_node("CardDB")
	CardInfo = get_parent().get_node("CardInfo")
	
	var deckList = DeckDB.deckContents.duplicate()
	for cardName in deckList:
		var cardInstance = cardUI.instantiate()
		cardInstance.cardName = cardName
		cardInstance.cardSelected.connect(cardSelected)
		cardInstance.cardInfo.connect(cardInfo)
		cardList.append(cardInstance)
		
		add_child(cardInstance)
		#searching card DB
		cardInstance.setCardStats(CardDB.getCardData(cardName))

func addCard(cardName):
	DeckDB.deckContents.append(cardName)
	
	var cardInstance = cardUI.instantiate()
	cardInstance.cardName = cardName
	cardInstance.cardSelected.connect(cardSelected)
	cardInstance.cardInfo.connect(cardInfo)
	cardList.append(cardInstance)
	
	add_child(cardInstance)
	#searching card DB
	cardInstance.setCardStats(CardDB.getCardData(cardName))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currX = startX
	currY = startY
	for card in cardList:
		card.position.y = currY
		card.position.x = currX
		
		#Incrementation
		currX += xIncrement
		if currX > endX:
			currX = startX
			currY += yIncrement

func cardSelected(cardNode):
	cardList.remove_at(cardList.find(cardNode))
	DeckDB.removeCard(cardNode.cardName)
	get_parent().get_node("ScrollContainer").get_node("VBoxContainer").addCard(cardNode.cardName)

func cardInfo(cardNode):
	CardInfo.cardName = cardNode.cardName
	CardInfo.HP = cardNode.hp
	CardInfo.ATK = cardNode.atk
	CardInfo.tributeCost = cardNode.tributeCost
	CardInfo.energyCost = cardNode.energyCost
	CardInfo.attributes = cardNode.attributes

func clearCards():
	for card in self.get_children():
		cardList.remove_at(cardList.find(card))
		self.remove_child(card)
		card.queue_free()
