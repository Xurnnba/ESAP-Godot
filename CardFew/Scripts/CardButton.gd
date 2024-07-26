extends Button

class_name CardButton

var cardName = ""

var hovered

signal cardPressed
signal cardInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mouse_entered.connect(_mouse_entered)
	self.mouse_exited.connect(_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = cardName

func _mouse_entered():
	hovered = true

func _mouse_exited():
	hovered = false

func _input(event):
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_RIGHT && hovered:
		cardInfo.emit(self)
	
	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && hovered:
		cardPressed.emit(self)
