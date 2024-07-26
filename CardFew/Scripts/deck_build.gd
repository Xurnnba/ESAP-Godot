extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_button_pressed():
	if get_parent().get_node("DeckDB").deckContents.size() >= 5:
		get_parent().switchScene(self, get_parent().get_node("MainMenu"))
	else:
		print("Deck must have at least 5 cards!")

func Enter():
	$DeckUI.startup()
	$ScrollContainer/VBoxContainer.startup()

func Exit():
	$DeckUI.clearCards()
	$ScrollContainer/VBoxContainer.clearButtons()
