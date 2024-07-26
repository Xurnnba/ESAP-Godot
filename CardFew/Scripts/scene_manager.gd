extends Node

@export var initialScene: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Use a relative path from the project root
	# var script_path = "/Users/TroyThe/9-30Cardfew/YamiNoGame/launch_server.zsh"
	# var output = []
	# await OS.execute("zsh",[script_path],output)
	
	initialScene.visible = true
	initialScene.Enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switchScene(currentScene, newScene):
	currentScene.visible = false
	currentScene.Exit()
	newScene.visible = true
	newScene.Enter()
