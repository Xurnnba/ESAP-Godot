extends Node2D

var handContents = []
var cardList = []
var cardsOnField = []

@export var card: PackedScene

#Fields for autocard placement
@export var EnemySlot1: Area2D
@export var EnemySlot2: Area2D
@export var EnemySlot3: Area2D
@export var EnemySlot4: Area2D
@export var EnemySlot5: Area2D
var EnemySlots = []

var rng = RandomNumberGenerator.new()

#Spacing var
var cardYVal = 48
var start = 576
var space = 90

# Called when the node enters the scene tree for the first time.
func startup():
	EnemySlots = [EnemySlot1, EnemySlot2, EnemySlot3, EnemySlot4, EnemySlot5]

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

func play(cardName, fieldSlot):
	if cardName in handContents:
		var cardNode = cardList[handContents.find(cardName)]
		handContents.remove_at(handContents.find(cardName))
		cardNode.playCard(fieldSlot)
		cardsOnField.append(cardNode)
		removeCards([cardNode])
		
		#Auto-placement - enemy exclusive
		#Tweening code
		var tween = get_tree().create_tween()
		tween.tween_property(cardNode, "position", EnemySlots[fieldSlot - 1].position, 0.1)
		EnemySlots[fieldSlot - 1].cardInSlot = cardNode
		
		
		return cardNode
	return null

func randCardName():
	if handContents.size() > 0:
		return handContents[rng.randi_range(0, handContents.size() - 1)]

func flipAllCards():
	for cardNode in cardsOnField:
		if cardNode && cardNode.set:
			cardNode.flipCard()
	
func discard(cardNodes):
	for cardNode in cardNodes:
		if cardNode.cardName in handContents:
			handContents.remove_at(handContents.find(cardNode.cardName))
			get_parent().get_node("EnemyDiscard").discardCards(cardNode.cardName)
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
		cardInstance.switchControl()
		
		cardInstance.position.y = cardYVal 
		
		#searching card DB
		cardInstance.setCardStats(get_parent().get_parent().get_node("CardDB").getCardData(cardName))
		
		cardsAdded.append(cardInstance)
		cardInstance.setCard()
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
	infoNode.attributes = cardNode.attributes

func cardLeftField(cardNode):
	EnemySlots[cardNode.fieldSlot - 1].cardInSlot = null
	
	cardsOnField.remove_at(cardsOnField.find(cardNode))
	
	#Moving card to discard
	get_parent().get_node("PlayerDiscard").discardCards([cardNode.cardName])

func clearCards():
	handContents = []
	cardsOnField = []
	for card in self.get_children():
		cardList.remove_at(cardList.find(card))
		self.remove_child(card)
		card.queue_free()
