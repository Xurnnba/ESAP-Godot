extends Area2D

var hovered = false

#Card Vals
var cardName = ""
var hp = 1
var atk = 0
var tributeCost = 0
var energyCost = 0
var attributes = []
var cardIMG = load("res://Sprites/Cards/TCard.png")

signal cardSelected
signal cardInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_mouse_entered():
	print("mou enter")
	hovered = true

func _on_mouse_exited():
	hovered = false

func _input(event):
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && hovered:
		cardInfo.emit(self)
	
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && hovered:
		print("clicked...")
		cardInfo.emit(self)
		cardSelected.emit(self)
		queue_free()

func setCardStats(stats):
	if stats:
		hp = stats[0]
		atk = stats[1]
		tributeCost = stats[2]
		energyCost = stats[3]
		attributes = stats[4]
		$Sprite2D.texture = stats[5]

func setImage(image):
	$Sprite2D.texture = image
