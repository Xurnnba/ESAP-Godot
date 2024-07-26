extends Node2D

var handContents = []
var cardList = []

@export var card: PackedScene

@export var PlayerSlot1: Area2D
@export var PlayerSlot2: Area2D
@export var PlayerSlot3: Area2D
@export var PlayerSlot4: Area2D
@export var PlayerSlot5: Area2D
var PlayerSlots = []

#Spacing var
var cardYVal =600
var start = 576
var space = 90

# Called when the node enters the scene tree for the first time.
func startup():
	PlayerSlots = [PlayerSlot1, PlayerSlot2, PlayerSlot3, PlayerSlot4, PlayerSlot5]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cardList.size() % 2 == 0:
		start = (576) - (space * cardList.size()/2) + space/2
	else:
		start = (576) - (space * (cardList.size()/2))
		#start = (576 - (space/cardList.size())) - (space * cardList.size()/2)
	for card in cardList:
		if card.inHand:
			card.position.x = start
			start += space

func play(cardNode, fieldSlot):
	if cardNode.cardName in handContents:
		handContents.remove_at(handContents.find(cardNode.cardName))
		cardNode.playCard(fieldSlot)
		removeCards([cardNode])
		
	
func discard(cardNodes):
	for cardNode in cardNodes:
		if cardNode.cardName in handContents:
			handContents.remove_at(handContents.find(cardNode.cardName))
			get_parent().get_node("PlayerDiscard").discardCards(cardNode.cardName)
	removeCards(cardNodes)

func addCards(cardNames):
	var cardsAdded = []
	for cardName in cardNames:
		handContents.append(cardName)
		
		var cardInstance = card.instantiate()
		cardInstance.cardName = cardName
		cardInstance.cardSelected.connect(cardSelected)
		cardInstance.cardInfo.connect(cardInfo)
		cardInstance.cardLeftField.connect(cardLeftField)
		cardInstance.inHand = true
		
		cardInstance.position.y = cardYVal 
		
		#searching card DB
		cardInstance.setCardStats(get_parent().get_parent().get_node("CardDB").getCardData(cardName))
		
		cardsAdded.append(cardInstance)
		cardList.append(cardInstance)
		add_child(cardInstance)
	return cardsAdded

func addCardNodes(cardNodes):
	for cardNode in cardNodes:
		handContents.append(cardNode.cardName)
		cardNode.inHand = true
		cardList.append(cardNode)
	

func removeCards(cardNodes):
	for cardNode in cardNodes:
		cardList.remove_at(cardList.find(cardNode))

func cardSelected(cardNode):
	get_parent().get_node("GameStateMachine").cardSelected.emit(cardNode)

func cardInfo(cardNode):
	var infoNode = get_parent().get_node("CardInfo")
	infoNode.cardName = cardNode.cardName
	infoNode.HP = cardNode.hp
	infoNode.ATK = cardNode.atk
	infoNode.tributeCost = cardNode.tributeCost
	infoNode.energyCost = cardNode.energyCost
	infoNode.attributes = cardNode.attributes

func cardLeftField(cardNode):
	PlayerSlots[cardNode.fieldSlot - 1].cardInSlot = null
	
	#Moving card to discard
	get_parent().get_node("PlayerDiscard").discardCards([cardNode.cardName])

func clearCards():
	handContents = []
	for card in self.get_children():
		cardList.remove_at(cardList.find(card))
		self.remove_child(card)
		card.queue_free()
