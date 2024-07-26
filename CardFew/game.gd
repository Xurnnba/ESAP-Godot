extends Node2D

var PlayerSlots = []
var EnemySlots = []

var gameRunning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerSlots = [$FieldSlot1, $FieldSlot2, $FieldSlot3, $FieldSlot4, $FieldSlot5]
	EnemySlots = [$EnemyFieldSlot1, $EnemyFieldSlot2, $EnemyFieldSlot3, $EnemyFieldSlot4, $EnemyFieldSlot5]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Enter():
	gameRunning = true
	$EnemyDeck.startup()
	$PlayerDeck.startup()
	$EnemyHand.startup()
	$PlayerHand.startup()
	
	$GameStateMachine.startup()
	
	$GameEnd.gameStart()
	
	$MessageBox.text = ""

func Exit():
	$EnemyHand.clearCards()
	
	$PlayerHand.clearCards()
	
	for X in PlayerSlots.size():
		PlayerSlots[X].cardInSlot = null
		EnemySlots[X].cardInSlot = null
	
	$EnemyDiscard.clearCards()
	$PlayerDiscard.clearCards()


func endGame(playerWon):
	gameRunning = false
	$GameEnd.gameEnd(playerWon)
	Exit()


func _on_exit_pressed():
	get_parent().switchScene(self, get_parent().get_node("MainMenu"))
