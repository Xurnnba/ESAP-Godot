extends Control

var playerWon

var startX = 100
var currX = startX
var XIncrement = 170

var yVal = 100

var cardList = []

@export var card: PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gameEnd(playerVictory):
	playerWon = playerVictory
	if playerVictory:
		$Label.text = "You Won!"
		$Next.text = "Continue"
		
		var prizePool = get_parent().get_parent().get_node("MainMenu").prizePool
		
		currX = startX
		for cardName in prizePool:
			var cardData = get_parent().get_parent().get_node("CardDB").getCardData(cardName)
			
			var cardInstance = card.instantiate()
			cardInstance.cardName = cardName
			cardInstance.cardSelected.connect(cardSelected)
			
			cardInstance.position.y = yVal
			cardInstance.position.x = currX
			cardInstance.z_index = 5
			currX += XIncrement
			
			cardList.append(cardInstance)
			get_parent().add_child(cardInstance)
			
			#searching card DB
			cardInstance.setCardStats(get_parent().get_parent().get_node("CardDB").getCardData(cardName))
		
		$Card1.visible = true
		$Card2.visible = true
		$Card3.visible = true
		
	else:
		$Label.text = "You Lost..."
		$Next.text = "Retry"
		$Card1.visible = false
		$Card2.visible = false
		$Card3.visible = false
	self.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,1), 1)

func gameStart():
	self.visible = false
	self.modulate.a = 0


func _on_next_pressed():
	if !playerWon:
		get_parent().Enter()
	else:
		if cardList.is_empty():
			get_parent().switchScene(self, get_parent().get_node("MainMenu"))

func cardSelected(cardNode):
	get_parent().get_parent().get_node("Inventory").addCards([cardNode.cardName])
	for card in cardList:
		card.queue_free()
	cardList = []
	get_parent().get_parent().get_node("MainMenu").prizePool = []


func _on_card_1_pressed():
	get_parent().get_parent().get_node("Inventory").addCards([cardList[0].cardName])
	for card in cardList:
		card.queue_free()
	cardList = []
	get_parent().get_parent().get_node("MainMenu").prizePool = []


func _on_card_2_pressed():
	get_parent().get_parent().get_node("Inventory").addCards([cardList[1].cardName])
	for card in cardList:
		card.queue_free()
	cardList = []
	get_parent().get_parent().get_node("MainMenu").prizePool = []


func _on_card_3_pressed():
	get_parent().get_parent().get_node("Inventory").addCards([cardList[2].cardName])
	for card in cardList:
		card.queue_free()
	cardList = []
	get_parent().get_parent().get_node("MainMenu").prizePool = []
