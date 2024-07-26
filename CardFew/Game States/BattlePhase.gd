extends GameState

class_name BattlePhase

#EnemySlot vars
@export var EnemySlot1: Area2D
@export var EnemySlot2: Area2D
@export var EnemySlot3: Area2D
@export var EnemySlot4: Area2D
@export var EnemySlot5: Area2D

#PlayerSlot vars
@export var PlayerSlot1: Area2D
@export var PlayerSlot2: Area2D
@export var PlayerSlot3: Area2D
@export var PlayerSlot4: Area2D
@export var PlayerSlot5: Area2D

var EnemySlots = []
var PlayerSlots = []

func Enter():
	phaseName = "Battle"
	#Flipping all enemy cards, making them visible
	get_parent().get_parent().get_node("EnemyHand").flipAllCards()
	
	#Displaying next message
	if get_parent().nextMessage != "":
		var messageBox = get_parent().get_parent().get_node("MessageBox")
		messageBox.text = get_parent().nextMessage + "\n" + messageBox.text
		playAudio()
	get_parent().nextMessage = ""
	
	#Camera node fetch
	var camera = get_parent().get_parent().get_node("Camera2D")
	var tween = get_tree().create_tween()
	var camTween = get_tree().create_tween()
	
	EnemySlots = [EnemySlot1, EnemySlot2, EnemySlot3, EnemySlot4, EnemySlot5]
	PlayerSlots = [PlayerSlot1, PlayerSlot2, PlayerSlot3, PlayerSlot4, PlayerSlot5]
	
	for X in EnemySlots.size():
		var EnemySlot = EnemySlots[X]
		var PlayerSlot = PlayerSlots[X]
		#Commence Slot X battle
		if EnemySlot.cardInSlot || PlayerSlot.cardInSlot:
			#Dynamic camera-ing
			camera.position.x = EnemySlot.position.x
			camera.position.y = (EnemySlot.position.y + PlayerSlot.position.y)/2
			#Tweening code
			camTween.tween_property(camera, "zoom", Vector2(1.4,1.4), 0.2)
			
			if !EnemySlot.cardInSlot && PlayerSlot.cardInSlot.atk > 0:
				get_parent().enemyHealth -= 1
			if  !PlayerSlot.cardInSlot && EnemySlot.cardInSlot.atk > 0:
				get_parent().playerHealth -= 1
			if EnemySlot.cardInSlot && PlayerSlot.cardInSlot:
				var pATK = PlayerSlot.cardInSlot.atk
				var eATK = EnemySlot.cardInSlot.atk
				
				if "Flying" in EnemySlot.cardInSlot.attributes && !"Flying" in PlayerSlot.cardInSlot.attributes:
					get_parent().playerHealth -= 1
				if "Flying" in PlayerSlot.cardInSlot.attributes && !"Flying" in EnemySlot.cardInSlot.attributes:
					get_parent().enemyHealth -= 1
				
				#Tweening attack anims
				if EnemySlot.cardInSlot.atk > 0 && !(("Flying" in EnemySlot.cardInSlot.attributes) && !("Flying" in PlayerSlot.cardInSlot.attributes)):
					tween = get_tree().create_tween()
					tween.tween_property(EnemySlot.cardInSlot, "position", Vector2(EnemySlot.position.x, EnemySlot.position.y - 10), 0.08).set_ease(Tween.EASE_IN)
					tween.tween_property(EnemySlot.cardInSlot, "position", Vector2(EnemySlot.position.x, EnemySlot.position.y + 80), 0.08).set_ease(Tween.EASE_IN)
					tween.tween_property(EnemySlot.cardInSlot, "position", Vector2(EnemySlot.position.x, EnemySlot.position.y), 0.2).set_ease(Tween.EASE_OUT)
					await create_tween().tween_interval(0.16).finished
					PlayerSlot.cardInSlot.hit(eATK)
					await create_tween().tween_interval(0.4).finished

				if PlayerSlot.cardInSlot && PlayerSlot.cardInSlot.atk > 0 && !(("Flying" in PlayerSlot.cardInSlot.attributes) && !("Flying" in EnemySlot.cardInSlot.attributes)):
					tween = get_tree().create_tween()
					tween.tween_property(PlayerSlot.cardInSlot, "position", Vector2(PlayerSlot.position.x, PlayerSlot.position.y + 10), 0.08).set_ease(Tween.EASE_IN)
					tween.tween_property(PlayerSlot.cardInSlot, "position", Vector2(PlayerSlot.position.x, PlayerSlot.position.y - 80), 0.1).set_ease(Tween.EASE_IN)
					tween.tween_property(PlayerSlot.cardInSlot, "position", Vector2(PlayerSlot.position.x, PlayerSlot.position.y), 0.2).set_ease(Tween.EASE_OUT)
					await create_tween().tween_interval(0.16).finished
					EnemySlot.cardInSlot.hit(pATK)
					await create_tween().tween_interval(0.4).finished
				
	await create_tween().tween_interval(0.4).finished
	#Camera to default
	camera.position = Vector2(576, 324)
	camTween = get_tree().create_tween()
	
	var camTweenTime = 0.2
	if get_parent().playerHealth <= 0 || get_parent().enemyHealth <= 0:
		camTweenTime = 0.7
	camTween.tween_property(camera, "zoom", Vector2(1,1), camTweenTime)

	await create_tween().tween_interval(camTweenTime).finished
	Exit()
	if get_parent().playerHealth <= 0:
		print("Player Lost!")
		get_parent().get_parent().endGame(false)
	elif get_parent().enemyHealth <= 0:
		print("Player Won!")
		get_parent().get_parent().endGame(true)
	else:
		Transitioned.emit(self.get_parent().get_node("EndPhase"), "EndPhase")
	
	camera.zoom = Vector2(1,1)

func playAudio():
	await create_tween().tween_interval(3).finished
	print("!!!!!Audio loaded")
#	var audioPlayer = AudioStreamWAV.new()
#	audioPlayer.stream = load("/Users/huangkangyi/Downloads/ESAP-Godot/CardFew/audio/speech.wav")
	var music = AudioStreamPlayer.new()
	add_child(music)
	var audio_loader = AudioLoader.new()
	music.set_stream(audio_loader.loadfile("res://audio/speech.mp3"))
	music.volume_db = 10
	music.pitch_scale = 1
	music.play()
#	add_child(audioPlayer)
#	audioPlayer.play()

func Exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta):
	pass

func findByClass(node: Node, className : String, result : Array) -> void:
	if node.is_class(className):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)

func Continue():
	pass
