extends Control
var scoreboard=0


var database := PostgreSQLClient.new()
const USER = "glzyjppg"
const PASSWORD = "AZ_Or2WXxqCS5WPFLDQ0WnKmFbLG2Fvx"
const HOST = "cornelius.db.elephantsql.com"
const PORT = 5432 # Default postgres port
const DATABASE = "glzyjppg" # Database name

enum sql_types {
	LEADERBOARDAKINA,
	LEADERBOARDSHUTOKO,
}

var sql_type = -1


func connectDB():
	var _error := database.connect("connection_established", self, "_execAll")
	_error = database.connect("authentication_error", self, "_authentication_error")
	_error = database.connect("connection_closed", self, "_close")	
	#Connection to the database
	_error = database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [USER, PASSWORD, HOST, PORT, DATABASE])



func _authentication_error(error_object: Dictionary) -> void:
	prints("Error connection to database:", error_object["message"])
	
func _close(clean_closure := true) -> void:
	prints("DB CLOSE,", "Clean closure:", clean_closure)
	
func _physics_process(_delta: float) -> void:
	database.poll()

func _exit_tree() -> void:
	database.close()
	
	
func _execAll():
	match sql_type:
		sql_types.LEADERBOARDAKIAN:
			_execLeaderboardAkina()
		sql_types.LEADERBOARDSHUTOKO:
			_execLeaderboardShutoko()


	
func _execLeaderboardAkina():
	var data = selectFromDB("BEGIN; SELECT * FROM test ORDER BY "+ '"scoreAkina"'+ "ASC; COMMIT;")
	var return_data = ""
	
	for d in data:
		for n in d.size():
			return_data += str(d[n]) + "\t"
		return_data += "\n"

func _execLeaderboardShutoko():
	var data = selectFromDB("BEGIN; SELECT * FROM test ORDER BY "+ '"scoreShutoko"'+ "ASC; COMMIT;")
	var return_data = ""
	
	for d in data:
		for n in d.size():
			return_data += str(d[n]) + "\t"
		return_data += "\n"

func selectFromDB(sql:String) -> Array:
	var datas := database.execute(sql)
	var rows = datas[1].data_row
	
	database.close()
	
	return rows

func _ready():
	$leaderboard_board.hide()
func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/menus/MapSelection.tscn")

func _on_Akina_pressed():
	scoreboard=1
	$leaderboard_board.show()

func _on_Shutoko_pressed():
	scoreboard=2
	$leaderboard_board.show()
