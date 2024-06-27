extends Control

var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "https://plannensplan.dk/db_test.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
const SECRET_KEY = "1234567890"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false


onready var GlobalVariable= get_node("/root/GlobalVar")
signal LBFetch

export var id=0
func _ready():
	randomize()
	
	# Connect our request handler:
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	# Connect our buttons:
	#$AddScore.connect("pressed", self, "_submit_score")
	#$GetScores.connect("pressed", self, "_get_scores")
	#$add.connect("pressed", self, "_add_account")
	#$login.connect("pressed", self, "_login_account")
	
	
	
func _process(_delta):
#	$BackgroundLayer/Background.get_rect().size.x = 255
#	$BackgroundLayer/Background.get_rect().size.y = 255
#	$BackgroundLayer/Background.rect_scale.x = 255 / $BackgroundLayer/Background.texture.get_size().x
#	$BackgroundLayer/Background.rect_scale.y = 255 / $BackgroundLayer/Background.texture.get_size().y
	if is_requesting:
		return
		
	if request_queue.empty():
		return
		
	is_requesting = true
	if nonce == null:
		request_nonce()
	else:
		_send_request(request_queue.pop_front())
	

	

	
	
func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != HTTPRequest.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
		
	var response_body = _body.get_string_from_utf8()
	# Grab our JSON and handle any errors reported by our PHP code:
	print(response_body)
	var response = parse_json(response_body)
	
	if response['error'] != "none":
		printerr("We returned error: " + response['error'])
		return
	
	# Check if we were requesting a nonce:
	if response['command'] == 'get_nonce':
		nonce = response['response']['nonce']
		#print("Got nonce: " + response['response']['nonce'])
		return
	if response["command"] == "account_login":
		handlelogin(response["response"])
	if response["command"] == "account_check":
		handlecheck(response["response"])
	if response["command"] == "account_add":
		handlesignup(response["response"])
	if response["command"] == "check_scores":
		handlecheckscores(response["response"])
	if response["command"] == "user_scores":
		scorechecking(response["response"])
	# If not requesting a nonce, we handle all other requests here:
	#print("Response Body:\n" + response_body)
	

func request_nonce():
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print({})})
	var body = "command=get_nonce&" + data
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, false, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	#print("Requesting nonce...")
	
func _send_request(request : Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.print(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	# Generate our 'response nonce'
	var cnonce = String(Crypto.new().generate_random_bytes(32)).sha256_text()
	
	# Generate our security hash:
	var client_hash = (nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	# Create our custom header for the request:
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	# Make request to the server:
	var err = http_request.request(SERVER_URL, headers, false, HTTPClient.METHOD_POST, body)
	
	# Check if there were problems:
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	# Print out request for debugging:
	#print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)




func _add_score(id, username, time, map):
	var command="score_add"
	var data = {"id":id, "time": time, "username": username, "map": map}
	request_queue.push_back({"command" : command, "data" : data});

func _insert_score(id, username, time, map):
	var command="score_insert"
	var data = {"id":id, "time": time, "username": username, "map": map}
	request_queue.push_back({"command" : command, "data" : data});
func _check_scores(map):
	var command="check_scores"
	var data = {"map": map}
	request_queue.push_back({"command" : command, "data" : data});
func _user_scores(id):
	var command="user_scores"
	var data = {"id": id}
	request_queue.push_back({"command" : command, "data" : data});
#func _get_user(id):
#	var command="get_user"
#	var data = {"user": id}
#	request_queue.push_back({"command" : command, "data" : data});
	
func handlecheckscores(data):
	GlobalVariable.lbfetch=data
	emit_signal("LBFetch")
	print(data)
	

func scorechecking(data):
	var shorthandle=GlobalVariable.temp
	print(shorthandle)
	print(data)
	
	if data.size() == 0 || not data:
		if not shorthandle.has("map"):
			return
		_insert_score(shorthandle.id, shorthandle.username, shorthandle.time, shorthandle.map)
		return
	if data[0].scoreAkina:
		GlobalVariable.OAkinaPassed=true
	if not shorthandle.has("map"):
		return
	if int(shorthandle.time) < int(data[0][shorthandle.map]):
		_add_score(shorthandle.id, shorthandle.username, shorthandle.time, shorthandle.map)
	pass

func _add_account(username, password):
	#var username = $LineEdit.text
	#var password = $LineEdit2.text
	var command = "account_add"
	var data = {"username" : username, "password" : password}
	request_queue.push_back({"command" : command, "data" : data});
	
func _login_account(username, password):
	#var username = $LineEdit.text
	#var password = $LineEdit2.text
	var command = "account_login"
	var data = {"username" : username, "password" : password}
	request_queue.push_back({"command" : command, "data" : data});
func _check_account(username):
	var command = "account_check"
	var data = {"username" : username}
	request_queue.push_back({"command" : command, "data" : data});


func _on_Login_pressed():
	$MainScene.visible=false
	$Login.visible=true
	pass # Replace with function body.

func _on_Signup_pressed():
	$MainScene.visible=false
	$Signup.visible=true
	pass # Replace with function body.


func _on_Logingame_pressed():
	var disallowedcharacters=[
		"/",
		";",
		":",
		"<",
		">",
		"*",
		"?",
		"|",
		"\\",
		'"',
		"'",
		".",
		",",
		"`",
		"´",
		"-",
		"+"
	]
	var disallowedpassword=[
		"/",
		";",
		":",
		"<",
		">",
		"|",
		"\\",
		'"',
		"'",
		"`",
		"´",
	]
	for i in disallowedcharacters:
		if i in $Login/Username.text:
			$Login/Warning2.show()
			return
	for i in disallowedpassword:
		if i in $Login/Password.text:
			$Login/Warning3.show()
			return
	if $Login/Password.text=="" or $Login/Username.text == "":
		$Login/Warning4.show()
		return
	$Login/Back.disabled=true
	$Login/Login.disabled=true	
	$Login/Username.editable=false
	$Login/Password.editable=false
	_login_account($Login/Username.text,$Login/Password.text)
	pass # Replace with function body.

func handlelogin(data):
	$Login/Back.disabled=false
	$Login/Login.disabled=false
	$Login/Username.editable=true
	$Login/Password.editable=true
	if not data:
		$Login/Warning.show()
		return
		
	GlobalVariable.id = data[0].id
	GlobalVariable.username=data[0].username
	
	#get_tree().quit()
	get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")
	pass


func _on_Back_pressed():
	if $Signup.visible:
		$Signup.visible=false
	if $Login.visible:
		$Login.visible=false
	if $Signup/Success.visible:
		$Signup/Success.visible=false
	$MainScene.visible=true
		
	pass # Replace with function body.


func _on_Login_text_changed(new_text):
	if $Login/Warning.visible:
		$Login/Warning.hide()
	if $Login/Warning2.visible:
		$Login/Warning2.hide()
	if $Login/Warning3.visible:
		$Login/Warning3.hide()
	if $Login/Warning4.visible:
		$Login/Warning4.hide()
	pass # Replace with function body.



func _on_Signupgame_pressed():
	var disallowedcharacters=[
		"/",
		";",
		":",
		"<",
		">",
		"*",
		"?",
		"|",
		"\\",
		'"',
		"'",
		".",
		",",
		"`",
		"´",
		"-",
		"+"
	]
	var disallowedpassword=[
		"/",
		";",
		":",
		"<",
		">",
		"|",
		"\\",
		'"',
		"'",
		"`",
		"´",
	]
	for i in disallowedcharacters:
		if i in $Signup/Username.text:
			$Signup/Warning2.show()
			return
	for i in disallowedpassword:
		if i in $Signup/Password.text:
			$Signup/Warning3.show()
			return
	if $Signup/Password.text == "" or $Signup/Username.text == "":
		$Signup/Warning4.show()
		return
	$Signup/Back.disabled=true
	$Signup/Signup.disabled=true
	$Signup/Username.editable=false
	$Signup/Password.editable=false
	_check_account($Signup/Username.text)
	pass # Replace with function body.

func handlecheck(data):
	$Signup/Back.disabled=false
	$Signup/Signup.disabled=false
	$Signup/Username.editable=true
	$Signup/Password.editable=true
	if data:
		$Signup/Warning.visible=true
		return
	_add_account($Signup/Username.text,$Signup/Password.text)
	pass

func handlesignup(data):
	$Signup/Success.show()
	


func _on_signup_text_changed(new_text):
	if $Signup/Warning.visible:
		$Signup/Warning.visible=false
	if $Signup/Warning2.visible:
		$Signup/Warning2.visible=false
	if $Signup/Warning3.visible:
		$Signup/Warning3.visible=false
	if $Signup/Warning4.visible:
		$Signup/Warning4.visible=false
	pass # Replace with function body.



