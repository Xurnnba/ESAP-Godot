extends VBoxContainer

var Inventory
var DeckDB
var CardInfo
var CardDB
var DeckUI

# Called when the node enters the scene tree for the first time.
func startup():
	#Defining all repeat-use node references
	CardDB = get_parent().get_parent().get_parent().get_node("CardDB")
	CardInfo = get_parent().get_parent().get_node("CardInfo")
	Inventory = get_parent().get_parent().get_parent().get_node("Inventory")
	DeckDB = get_parent().get_parent().get_parent().get_parent().get_node("DeckDB")
	DeckUI = get_parent().get_parent().get_node("DeckUI")
	
	for cardName in Inventory.inventory:
		var newButton = CardButton.new()
		newButton.cardName = cardName
		newButton.custom_minimum_size.y = 150
		newButton.cardPressed.connect(cardPressed)
		newButton.cardInfo.connect(cardInfo)

		add_child(newButton)

func addCard(cardName):
	var newButton = CardButton.new()
	newButton.cardName = cardName
	newButton.custom_minimum_size.y = 150
	newButton.cardPressed.connect(cardPressed)
	newButton.cardInfo.connect(cardInfo)
	
	Inventory.addCards([cardName])
	
	add_child(newButton)

func cardPressed(buttonNode):
	Inventory.removeCard(buttonNode.text)
	DeckUI.addCard(buttonNode.cardName)
	buttonNode.queue_free()

func cardInfo(buttonNode):
	var cardData = CardDB.getCardData(buttonNode.cardName)
	if cardData:
		CardInfo.cardName = buttonNode.cardName
		CardInfo.HP = cardData[0]
		CardInfo.ATK = cardData[1]
		CardInfo.tributeCost = cardData[2]
		CardInfo.energyCost = cardData[3]

func clearButtons():
	for button in self.get_children():
		self.remove_child(button)
		button.queue_free()
