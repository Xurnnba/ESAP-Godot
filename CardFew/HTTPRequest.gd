extends Node

signal imageOutputSignal
signal cardOutputSignal
signal narrativeOutputSignal
signal audioOutputSignal

func _ready():
	# In the actual game, replace the description below with the desired description
	#make_post_request(15,testPrint)
	pass

func testPrint(response):
	get_parent().get_node("DeckDB").addCards(response)
	#$Sprite2D.texture = response
	
	
#Card Creation Method
func make_post_request(number, returnFunction, theme):
	#Decription attributes
	var description = "I want " + str(number) + " cards of varying power"
	if theme:
		description += " with a " + theme + " theme"
	
	# create an instance of an HTTP Request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	cardOutputSignal.connect(returnFunction)

	# The properties of the request, no need to change
	var url = "http://localhost:15414/card"
	var headers = ["Content-Type: application/json"]
	var body = JSON.new().stringify({"description": description})
	

	# The way this script receive the response is by, 1. see if there is an error
	# 2. if no error, it means the response is no problem
	# 3. in that case, process the response
	# 4. if error, throw an exception and print error message
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	print(error)
	if error != OK:
		print("An error occurred in the HTTP request.")
		
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		# if error == OK:
			# convert the http response to processable format
		var response = json.get_data()
		cardOutputSignal.emit(response)
		var conns = cardOutputSignal.get_connections()
		for conn in conns:
			cardOutputSignal.disconnect(conn.get("callable"))
			# response is a list of dictionaries of each card!!!!!!!need to process it
			#####################################################
			#####################################################
		# else:
			# print("JSON Parse Error: ", json.get_error_message())
	else:
		print("Error: ", result)
		print(response_code)

#Image Download Methods
func image_download_request(url, returnFunction):
	# create an instance of an HTTP Request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_image_request_completed"))
	imageOutputSignal.connect(returnFunction)
	
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(url)
	if error != OK:
		print("An error occurred in the HTTP request.")

func _image_request_completed(result, response_code, headers, body):
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:	
		print("Couldn't load the image.")
	else:
		var texture = ImageTexture.create_from_image(image)
	
		imageOutputSignal.emit(texture)
		var conns = imageOutputSignal.get_connections()
		for conn in conns:
			imageOutputSignal.disconnect(conn.get("callable"))

#Card Creation Method
func narrative_request(cardName, hp, atk, attributes, returnFunction):
	#Decription attributes
	var description = "You play a card named " + cardName + " with " + str(hp) + " HP, " + str(atk) + " ATK "
	if attributes:
		description += "and with " + str(attributes)
	
	# create an instance of an HTTP Request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_narrative_completed"))
	narrativeOutputSignal.connect(returnFunction)

	# The properties of the request, no need to change
	var url = "http://localhost:15414/narrative"
	var headers = ["Content-Type: application/json"]
	var body = JSON.new().stringify({"description": description})
	

	# The way this script receive the response is by, 1. see if there is an error
	# 2. if no error, it means the response is no problem
	# 3. in that case, process the response
	# 4. if error, throw an exception and print error message
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	print(error)
	if error != OK:
		print("An error occurred in the HTTP request.")
	
func _on_narrative_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		# if error == OK:
			# convert the http response to processable format
		var response = json.get_data()
		narrativeOutputSignal.emit(response)
		var conns = narrativeOutputSignal.get_connections()
		for conn in conns:
			print(conn)
			narrativeOutputSignal.disconnect(conn.get("callable"))
			# response is a list of dictionaries of each card!!!!!!!need to process it
			#####################################################
			#####################################################
		# else:
			# print("JSON Parse Error: ", json.get_error_message())
	else:
		print("Error: ", result)
		print(response_code)

func audio_request(message, returnFunction):
	# create an instance of an HTTP Request
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_audio_completed"))
	audioOutputSignal.connect(returnFunction)

	# The properties of the request, no need to change
	var url = "http://localhost:15414/speech"
	var headers = ["Content-Type: application/json"]
	var body = JSON.new().stringify({"description": message})
	

	# The way this script receive the response is by, 1. see if there is an error
	# 2. if no error, it means the response is no problem
	# 3. in that case, process the response
	# 4. if error, throw an exception and print error message
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	print(error)
	if error != OK:
		print("An error occurred in the HTTP request.")

func _on_audio_completed(result, response_code, headers, body):
	print("Audio done!")
	audioOutputSignal.emit()
	var conns = audioOutputSignal.get_connections()
	for conn in conns:
		audioOutputSignal.disconnect(conn.get("callable"))
