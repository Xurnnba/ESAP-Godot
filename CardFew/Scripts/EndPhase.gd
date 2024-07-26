extends GameState
class_name EndPhase

#Enemy Slot vars
var EnemySlots = []
@export var EnemySlot1: Area2D
@export var EnemySlot2: Area2D
@export var EnemySlot3: Area2D
@export var EnemySlot4: Area2D
@export var EnemySlot5 : Area2D

#Player Slot vars
var PlayerSlots = []
@export var PlayerSlot1: Area2D
@export var PlayerSlot2: Area2D
@export var PlayerSlot3: Area2D
@export var PlayerSlot4: Area2D
@export var PlayerSlot5: Area2D

var rng = RandomNumberGenerator.new()

func Enter():
	phaseName = "End"
	#Filling slot arrays
	EnemySlots = [EnemySlot1, EnemySlot2, EnemySlot3, EnemySlot4, EnemySlot5]
	PlayerSlots = [PlayerSlot1, PlayerSlot2, PlayerSlot3, PlayerSlot4, PlayerSlot5]
	
	get_parent().get_parent().get_node("Camera2D").zoom = Vector2(1,1)
	
	#Looping through Player & Enemy slots
	for X in PlayerSlots.size():
		var PlayerSlot = PlayerSlots[X]
		
		if PlayerSlot.cardInSlot && "Right Jump" in PlayerSlot.cardInSlot.attributes && PlayerSlot.fieldNum != PlayerSlots.size() && !PlayerSlots[X+1].cardInSlot && !PlayerSlot.cardInSlot.moved:
			PlayerSlot.cardInSlot.fieldSlot += 1
			var tween = get_tree().create_tween()
			tween.tween_property(PlayerSlot.cardInSlot, "position", PlayerSlots[X+1].position, 0.1)
			
			PlayerSlot.cardInSlot.moved = true
			PlayerSlots[X+1].cardInSlot = PlayerSlot.cardInSlot
			PlayerSlot.cardInSlot = null
			
		
		if PlayerSlot.cardInSlot && "Left Jump" in PlayerSlot.cardInSlot.attributes && PlayerSlot.fieldNum != 1 && !PlayerSlots[X-1].cardInSlot && !PlayerSlot.cardInSlot.moved:
			PlayerSlot.cardInSlot.fieldSlot -= 1
			var tween = get_tree().create_tween()
			tween.tween_property(PlayerSlot.cardInSlot, "position", PlayerSlots[X-1].position, 0.1)
			
			PlayerSlot.cardInSlot.moved = true
			PlayerSlots[X-1].cardInSlot = PlayerSlot.cardInSlot
			PlayerSlot.cardInSlot = null
		
		if PlayerSlot.cardInSlot && "Defender" in PlayerSlot.cardInSlot.attributes && !PlayerSlot.cardInSlot.moved:
			var viableDefense = []
			for Y in PlayerSlots.size():
				if EnemySlots[Y].cardInSlot && !PlayerSlots[Y].cardInSlot:
					viableDefense.append(PlayerSlots[Y])
			
			if viableDefense.size() > 0:
				var slot = viableDefense[rng.randi_range(0, viableDefense.size() - 1)]
				
				PlayerSlot.cardInSlot.fieldSlot = slot.fieldNum
				var tween = get_tree().create_tween()
				tween.tween_property(PlayerSlot.cardInSlot, "position", slot.position, 0.1)
				
				PlayerSlot.cardInSlot.moved = true
				slot.cardInSlot = PlayerSlot.cardInSlot
				PlayerSlot.cardInSlot = null
		
		if PlayerSlot.cardInSlot && "Withering" in PlayerSlot.cardInSlot.attributes:
			PlayerSlot.cardInSlot.atk -= 1
		
	for X in EnemySlots.size():
		var EnemySlot = EnemySlots[X]
		if EnemySlot.cardInSlot && "Right Jump" in EnemySlot.cardInSlot.attributes && EnemySlot.fieldNum != EnemySlots.size() && !EnemySlots[X+1].cardInSlot && !EnemySlot.cardInSlot.moved:
			EnemySlot.cardInSlot.fieldSlot += 1
			var tween = get_tree().create_tween()
			tween.tween_property(EnemySlot.cardInSlot, "position", EnemySlots[X+1].position, 0.1)
			
			EnemySlot.cardInSlot.moved = true
			EnemySlots[X+1].cardInSlot = EnemySlot.cardInSlot
			EnemySlot.cardInSlot = null
			
		if EnemySlot.cardInSlot && "Left Jump" in EnemySlot.cardInSlot.attributes && EnemySlot.fieldNum != 1 && !EnemySlots[X-1].cardInSlot && !EnemySlot.cardInSlot.moved:
			EnemySlot.cardInSlot.fieldSlot -= 1
			var tween = get_tree().create_tween()
			tween.tween_property(EnemySlot.cardInSlot, "position", EnemySlots[X-1].position, 0.1)
			
			EnemySlot.cardInSlot.moved = true
			EnemySlots[X-1].cardInSlot = EnemySlot.cardInSlot
			EnemySlot.cardInSlot = null
		
		if EnemySlot.cardInSlot && "Defender" in EnemySlot.cardInSlot.attributes && !EnemySlot.cardInSlot.moved:
			var viableDefense = []
			for Y in EnemySlots.size():
				if PlayerSlots[Y].cardInSlot && !EnemySlots[Y].cardInSlot:
					viableDefense.append(EnemySlots[Y])
			
			if viableDefense.size() > 0:
				print(viableDefense)
				var slot = viableDefense[rng.randi_range(0, viableDefense.size() - 1)]
				print(slot)
				
				EnemySlot.cardInSlot.fieldSlot = slot.fieldNum
				var tween = get_tree().create_tween()
				tween.tween_property(EnemySlot.cardInSlot, "position", slot.position, 0.1)
				
				EnemySlot.cardInSlot.moved = true
				slot.cardInSlot = EnemySlot.cardInSlot
				EnemySlot.cardInSlot = null
		
		if EnemySlot.cardInSlot && "Withering" in EnemySlot.cardInSlot.attributes:
			EnemySlot.cardInSlot.atk -= 1

	#Resetting movement "cooldown"
	for EnemySlot in EnemySlots:
		if EnemySlot.cardInSlot:
			EnemySlot.cardInSlot.moved = false
	for PlayerSlot in PlayerSlots:
		if PlayerSlot.cardInSlot:
			PlayerSlot.cardInSlot.moved = false
		
	await create_tween().tween_interval(0.2).finished
	Exit()
	Transitioned.emit(self.get_parent().get_node("DrawPhase"), "DrawPhase")

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func Card_Selected(cardNode):
	pass

func Slot_Chosen(slotNode):
	pass

func Continue():
	pass

func findByClass(node: Node, className : String, result : Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)

