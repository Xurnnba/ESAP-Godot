extends Node

var server_pid: int = -1

func _ready():
	# Use a relative path from the project root
	# var script_path = "/Users/huangkangyi/Downloads/ESAP-Godot/CardFew/launch_server.zsh"
	# var output = []
	# await OS.execute("zsh",[script_path],output)
	# server_pid = result.pid
	# print("down")


# func stop_server():
	#if server_pid != -1:
		#var kill_command = "kill -9 " + str(server_pid)
		#OS.execute("sh", ["-c", kill_command], [])
		#print("Server process killed")
		#server_pid = -1

#func _exit_tree():
		# stop_server()
