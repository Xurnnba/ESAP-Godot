extends GameState

class_name DrawPhase

func Enter():
	get_parent().get_parent().get_node("Camera2D").zoom = Vector2(1,1)
	
	phaseName = "Draw"
	
	if get_parent().get_parent().gameRunning:
		get_parent().turn +=1
		get_parent().energy = get_parent().turn
		if get_parent().turn == 1:
			get_parent().get_parent().get_node("EnemyDeck").draw(5)
			get_parent().get_parent().get_node("PlayerDeck").draw(5)
		else:
			get_parent().get_parent().get_node("EnemyDeck").draw(1)
			get_parent().get_parent().get_node("PlayerDeck").draw(1)
		
		if get_parent().turn > 1:
			await create_tween().tween_interval(0.2).finished
			Exit()
			Transitioned.emit(self.get_parent().get_node("ActionPhase"), "ActionPhase")

func Exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta):
	pass

#func _input(event):
#	if event.is_pressed() && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && get_parent().current_state == self:
#		Exit()
#		Transitioned.emit(self.get_parent().get_node("ActionPhase"), "ActionPhase")

func Continue():
	if get_parent().turn ==  1:
		Exit()
		Transitioned.emit(self.get_parent().get_node("ActionPhase"), "ActionPhase")
