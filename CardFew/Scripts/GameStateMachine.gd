extends Node

var current_state : GameState
var states : Dictionary = {}

@export var initial_state: GameState


#card select signal
signal cardSelected

#Game vars
var turn = 0
var playerHealth = 5
var enemyHealth = 10
var energy = turn
var nextMessage = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = $GameState

func startup():
	turn = 0
	playerHealth = 5
	enemyHealth = 10
	energy = turn
	
	for child in get_children():
		if child is GameState:
			
			child.set_process(false)
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.Update(delta)

func on_child_transition(state, new_state_name):
	if state == current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state


func _on_card_selected(cardNode):
	current_state.Card_Selected(cardNode)


func _on_field_slot_chosen(slotNode):
	current_state.Slot_Chosen(slotNode)



func _on_continue_pressed():
	current_state.Continue()
