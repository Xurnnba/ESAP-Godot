extends GameState

class_name ActionPhase

#Selected vars
var selectedCard
var isSelected = false

#Card Cost Tracking
var tributeCost = 0
var tributesChosen = []

#EnemySlot vars
@export var EnemySlot1: Area2D
@export var EnemySlot2: Area2D
@export var EnemySlot3: Area2D
@export var EnemySlot4: Area2D
@export var EnemySlot5: Area2D
var EnemySlots = []

#PlayerSlot vars
@export var PlayerSlot1: Area2D
@export var PlayerSlot2: Area2D
@export var PlayerSlot3: Area2D
@export var PlayerSlot4: Area2D
@export var PlayerSlot5: Area2D
var PlayerSlots = []

var rng = RandomNumberGenerator.new()
signal playAudio

func Enter():
	phaseName = "Action"
	get_parent().get_parent().get_node("Camera2D").zoom = Vector2(1,1)
	var EnemySlots = [EnemySlot1, EnemySlot2, EnemySlot3, EnemySlot4, EnemySlot5]
	PlayerSlots = [PlayerSlot1, PlayerSlot2, PlayerSlot3, PlayerSlot4, PlayerSlot5]
	if get_parent().get_parent().gameRunning:
		#Temp enemy placing code
		for X in get_parent().turn:
			var enemyPlacementSlot = rng.randi_range(1, EnemySlots.size())
			var chosenEnemySlot
			chosenEnemySlot = EnemySlots[enemyPlacementSlot - 1]
			
			var randCardName =get_parent().get_parent().get_node("EnemyHand").randCardName()
			if !chosenEnemySlot.cardInSlot:
				get_parent().get_parent().get_node("EnemyHand").play(randCardName, chosenEnemySlot.fieldNum)
			
			if rng.randi_range(1,4) == 1 && get_parent().nextMessage == "":
				print("Generating message")
				var cardData = get_parent().get_parent().get_parent().get_node("CardDB").getCardData(randCardName)
				if cardData:
					get_parent().get_parent().get_parent().get_node("HTTPRequest").narrative_request(randCardName, cardData[0], cardData[1], cardData[4], returnNarrative)

func returnNarrative(message):
	get_parent().nextMessage = "Enemy: " + message.get("description")
	print("Message Generated...")
	print(message)
	get_parent().get_parent().get_parent().get_node("HTTPRequest").audio_request(message.get("description"), emitAudio)

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func Card_Selected(cardNode):
	if !PlayerSlot1.hovered && !PlayerSlot2.hovered && !PlayerSlot3.hovered && !PlayerSlot4.hovered && !PlayerSlot5.hovered:
		if(selectedCard):
			selectedCard.select()
		selectedCard = cardNode
		cardNode.select()
		tributeCost = cardNode.tributeCost
		tributesChosen = []
		isSelected = true
	elif selectedCard && ((tributeCost != 0 && tributesChosen.size() < tributeCost) || "Devourer" in selectedCard.attributes || "Sacrifice" in selectedCard.attributes) && !(cardNode in tributesChosen):
		tributesChosen.append(cardNode)

func Slot_Chosen(slotNode):
	if isSelected && selectedCard.inHand && !slotNode.cardInSlot && (tributesChosen.size() == tributeCost || "Devourer" in selectedCard.attributes || "Sacrifice" in selectedCard.attributes) && selectedCard.energyCost <= get_parent().energy:
#		if slotNode.cardInSlot:
#			slotNode.cardInSlot.position.y = get_parent().get_parent().get_node("PlayerHand").cardYVal
#			get_parent().get_parent().get_node("PlayerHand").addCardNodes([slotNode.cardInSlot])
		get_parent().get_parent().get_node("PlayerHand").play(selectedCard, slotNode.fieldNum)
		selectedCard.select()
		
		#Tweening code
		var tween = get_tree().create_tween()
		tween.tween_property(selectedCard, "position", slotNode.position, 0.1)
		
#		selectedCard.position = slotNode.position
		slotNode.cardInSlot = selectedCard
		get_parent().energy -= selectedCard.energyCost
		selectedCard.tributeSummon(tributesChosen.size())
		selectedCard = null
		isSelected = false
		tributeCost = 0
		
		#Removing all tributes
		for tribute in tributesChosen:
			for PlayerSlot in PlayerSlots:
				if PlayerSlot.cardInSlot == tribute:
					PlayerSlot.cardInSlot = null
			tribute.discard()
		
		tributesChosen = []
#	elif !isSelected && slotNode.cardInSlot:
#		slotNode.cardInSlot.position.y = get_parent().get_parent().get_node("PlayerHand").cardYVal
#		get_parent().get_parent().get_node("PlayerHand").addCardNodes([slotNode.cardInSlot])
#		selectedCard = null
#		isSelected = false
#		slotNode.cardInSlot = null

func Continue():
	Exit()
	Transitioned.emit(self.get_parent().get_node("BattlePhase"), "BattlePhase")

func emitAudio():
	pass
