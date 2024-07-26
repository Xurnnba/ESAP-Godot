extends Area2D

#Hovered boolean
var hovered = false

signal enemySlotChosen
@export var fieldNum: int

#Card Stored
var cardInSlot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false

func _input(event):
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && hovered:
		enemySlotChosen.emit(self)
