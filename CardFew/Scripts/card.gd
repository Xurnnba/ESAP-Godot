extends Node2D

#Hovered boolean
var hovered = false
var shiftVal = 50

#Card Data
var cardName
var fieldSlot
var inHand
var hp = 1
var atk = 0
var tributeCost = 0
var energyCost = 0
var attributes = []
var cardIMG = load("res://Sprites/Cards/TCard.png")
var cardFront = load("res://Sprites/Cards/BlankCard.png")
var set
var playerCard = true
var selected = false
var regScale
var selectScale

var moved = false

var rng = RandomNumberGenerator.new()

#Pressed Signal
signal cardSelected
signal cardInfo
signal cardLeftField

# Called when the node enters the scene tree for the first time.
func _ready():
	regScale = scale
	selectScale = scale * 1.25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		scale = selectScale
	else:
		scale = regScale

func playCard(placedFieldSlot):
	fieldSlot = placedFieldSlot
	inHand = false
	
	if "Mimic" in attributes:
		if playerCard:
			if get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot:
				attributes = get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot.attributes 
		else:
			if get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot:
				attributes = get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot.attributes
	
	if "Necromancer" in attributes:
		var discardName = "PlayerDiscard"
		if !playerCard:
			discardName = "EnemyDiscard"
		var cardName = get_parent().get_parent().get_node(discardName).randomCard()
		if cardName:
			var cardsAdded = get_parent().addCards([cardName])
			for cardNode in cardsAdded:
				cardNode.energyCost = 0
	
	if "Right Boost" in attributes && fieldSlot != 5:
		if playerCard && get_parent().PlayerSlots[fieldSlot].cardInSlot:
			get_parent().PlayerSlots[fieldSlot].cardInSlot.atk += 1
		elif !playerCard && get_parent().EnemySlots[fieldSlot].cardInSlot:
			get_parent().EnemySlots[fieldSlot].cardInSlot.atk += 1
	if "Left Boost" in attributes && fieldSlot != 1:
		if playerCard && get_parent().PlayerSlots[fieldSlot - 2].cardInSlot:
			get_parent().PlayerSlots[fieldSlot - 2].cardInSlot.atk += 1
		elif !playerCard && get_parent().EnemySlots[fieldSlot - 2].cardInSlot:
			get_parent().EnemySlots[fieldSlot - 2].cardInSlot.atk += 1
	
	if "Healer" in attributes && fieldSlot != 5:
		if playerCard && get_parent().PlayerSlots[fieldSlot].cardInSlot:
			get_parent().PlayerSlots[fieldSlot].cardInSlot.hp += 1
		elif !playerCard && get_parent().EnemySlots[fieldSlot].cardInSlot:
			get_parent().EnemySlots[fieldSlot].cardInSlot.hp += 1
		if playerCard && get_parent().PlayerSlots[fieldSlot - 2].cardInSlot:
			get_parent().PlayerSlots[fieldSlot - 2].cardInSlot.hp += 1
		elif !playerCard && get_parent().EnemySlots[fieldSlot - 2].cardInSlot:
			get_parent().EnemySlots[fieldSlot - 2].cardInSlot.hp += 1
	
	if "Shockwave" in attributes:
		if playerCard:
			if fieldSlot != 5 && get_parent().PlayerSlots[fieldSlot].cardInSlot:
				get_parent().PlayerSlots[fieldSlot].cardInSlot.hit(1)
			if fieldSlot != 1 && get_parent().PlayerSlots[fieldSlot - 2].cardInSlot:
				get_parent().PlayerSlots[fieldSlot - 2].cardInSlot.hit(1)
			if get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot.hit(1)
		else:
			if fieldSlot != 5 && get_parent().EnemySlots[fieldSlot].cardInSlot:
				get_parent().EnemySlots[fieldSlot].cardInSlot.hit(1)
			if fieldSlot != 1 && get_parent().EnemySlots[fieldSlot - 2].cardInSlot:
				get_parent().EnemySlots[fieldSlot - 2].cardInSlot.hit(1)
			if get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot.hit(1)
	
	if "Nullify" in attributes:
		if playerCard:
			if get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot.attributes = []
		else:
			if get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot.attributes = []
	
	if "Curse" in attributes:
		if playerCard:
			if get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("EnemyHand").EnemySlots[fieldSlot - 1].cardInSlot.attributes.append("Withering")
		else:
			if get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot:
				get_parent().get_parent().get_node("PlayerHand").PlayerSlots[fieldSlot - 1].cardInSlot.attributes.append("Withering")
	
	if "Illusion" in attributes:
		get_parent().addCards(["Mirage"])

func setCardStats(stats):
	if stats:
		hp = stats[0]
		atk = stats[1]
		tributeCost = stats[2]
		energyCost = stats[3]
		attributes = stats[4]
		cardIMG = stats[5]
		$Sprite2D.texture = cardIMG

func setCard():
	set = true
	$CardFront.texture = load("res://Sprites/Cards/SetCard.png")

func flipCard():
	set = false
	$CardFront.texture = cardFront

func switchControl():
	playerCard = !playerCard
	shiftVal *= -1
	self.scale.y *= -1

func hit(damage):
	if !"Barrier" in attributes:
		hp -= damage
	else:
		attributes.remove_at(attributes.find("Barrier"))
	
	if "Beserk" in attributes:
			atk += damage
	
	if hp <= 0:
		if "Revival" in attributes:
			if rng.randi_range(1,3) != 1:
				get_parent().addCards([cardName])
		if "Restock" in attributes:
			var deckName = "PlayerDeck"
			if !playerCard:
				deckName = "EnemyDeck"
			get_parent().get_parent().get_node(deckName).draw(1)
		
		cardLeftField.emit(self)
		queue_free()

func tributeSummon(tributeCount):
	if "Devourer" in attributes:
		atk += 2 * tributeCount
	if "Sacrifice" in attributes:
		hp += 2 * tributeCount

func select():
	selected = !selected

func discard():
	cardLeftField.emit(self)
	queue_free()

func _on_mouse_entered():
	hovered = true
	if inHand:
		$BaseCollision.disabled = true
		$HoveredCollision.disabled = false
		self.position.y = get_parent().cardYVal - shiftVal


func _on_mouse_exited():
	hovered = false
	if inHand:
		$BaseCollision.disabled = false
		$HoveredCollision.disabled = true
		self.position.y = get_parent().cardYVal

func _input(event):
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && hovered && (playerCard || !set):
		cardInfo.emit(self)
	
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && hovered && playerCard:
		cardSelected.emit(self)
		cardInfo.emit(self)
