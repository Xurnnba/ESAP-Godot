extends TextEdit

var cardName = ""
var HP = ""
var ATK = ""
var tributeCost = ""
var energyCost = ""
var attributes = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Card Name: " + str(cardName) + "\n" + "HP: " + str(HP) + "\n" + "ATK: " + str(ATK) + "\n" + "Tribute Cost: " + str(tributeCost) + "\n" + "Energy Cost: " + str(energyCost) + "\n" + "Attributes: " + str(attributes) + "\n"
