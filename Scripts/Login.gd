extends Control

#var username=""
#var password=""
var checkusername="test"
var checkpassword="test"
var login=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


#onready var show_data = $ShowData
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#func _physics_process(delta):
#	pass
var database := PostgreSQLClient.new()
const USER = "glzyjppg"
const PASSWORD = "AZ_Or2WXxqCS5WPFLDQ0WnKmFbLG2Fvx"
const HOST = "cornelius.db.elephantsql.com"
const PORT = 5432 # Default postgres port
const DATABASE = "glzyjppg" # Database name

enum sql_types {
	INSERT,
	SELECT,
	CHECKNAME,
	PASSWORD,
}

var sql_type = -1

func connectDB():
	var _error := database.connect("connection_established", self, "_execAll")
	_error = database.connect("authentication_error", self, "_authentication_error")
	_error = database.connect("connection_closed", self, "_close")	
	#Connection to the database
	_error = database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [USER, PASSWORD, HOST, PORT, DATABASE])

# Called every frame. 'delta' is the elapsed time since the previous frame.

signal passwordchecker
var passwordvalid=false
func _on_Login_button_pressed():
	checkusername=$Username.text
	checkpassword=$Password.text
	sql_type= sql_types.PASSWORD
	connectDB()
	
func _on_passwordchecker():
	#print("yes")
	if passwordvalid==true:
		var MapSettings= get_node("/root/GlobalVar")
		MapSettings.Username = checkusername
		get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")
	else:
		$Popup/Label.text="login failed"
		visPopup()


signal usernamevalidsignal
var usernamevalid=false
func _on_Create_button_pressed():
	checkusername=$Username.text
	sql_type = sql_types.CHECKNAME
	connectDB()
func _on_usernamesignal():	
	if usernamevalid:	
		checkpassword=$Password.text
		$Popup/Label.text="Created account"
		sql_type = sql_types.INSERT
		connectDB()
	
		visPopup()
	else:
		$Popup/Label.text="Username is taken"
		visPopup()

func _on_Timer_timeout():
	$Popup.hide()
func visPopup():
	$Popup.show()
	$Popup/Timer.start(1)

func _authentication_error(error_object: Dictionary) -> void:
	prints("Error connection to database:", error_object["message"])
	
func _close(clean_closure := true) -> void:
	prints("DB CLOSE,", "Clean closure:", clean_closure)
	
func _physics_process(_delta: float) -> void:
	database.poll()

func _exit_tree() -> void:
	database.close()

#Call database function
func _execAll():
	match sql_type:
		sql_types.INSERT:
			_execInsert()
		sql_types.SELECT:
			_execSelect()
		sql_types.CHECKNAME:
			_execCheckname()
		sql_types.PASSWORD:
			_execPassword()
			
#Insert, Select, Update & Delete : setup data & SQL
func _execInsert():
	var data = [[str(checkusername),str(checkpassword)]]
	#print(data)
	insertToDB('BEGIN; INSERT INTO test ("username", "password") VALUES'+ " ('%s','%s'); COMMIT;", data)

func _execSelect():
	
	var data = selectFromDB("BEGIN; SELECT * FROM test; COMMIT;")
	var return_data = ""
	
	for d in data:
		for n in d.size():
			return_data += str(d[n]) + "\t"
			#print(d[n])
		return_data += "\n"
		
	#show_data.set_text(return_data)
func _execCheckname():
	var data = selectFromDB("BEGIN; SELECT * FROM test; COMMIT;")
	#print("d")
	usernamevalid=true
	if not data.empty():
		for d in data:
			#print(str(d[0]))
			if str(d[0])==checkusername:
				usernamevalid=false
				break
	emit_signal("usernamevalidsignal")
	
func _execPassword():
	var data = selectFromDB("BEGIN; SELECT * FROM test; COMMIT;")
	#print("d")
	if not data.empty():
		for d in data:
			if str(d[0])==checkusername && str(d[1])==checkpassword:
				if d[2] != null:
					var MapSettings= get_node("/root/GlobalVar")
					MapSettings.OAkinaPassed=true
									
				passwordvalid=true
				break
				
	emit_signal("passwordchecker")
	


#Insert, Select, Update & Delete executes
func insertToDB(sql: String, data: Array):
	var _sql
	for d in data:
		_sql = sql % d
		database.execute(_sql)
		print(_sql)

	database.close()

func selectFromDB(sql:String) -> Array:
	var datas := database.execute(sql)
	var rows = datas[1].data_row
	
	database.close()
	
	return rows



