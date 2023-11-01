extends CanvasLayer
var database := PostgreSQLClient.new()
const USER = "glzyjppg"
const PASSWORD = "AZ_Or2WXxqCS5WPFLDQ0WnKmFbLG2Fvx"
const HOST = "cornelius.db.elephantsql.com"
const PORT = 5432 # Default postgres port
const DATABASE = "glzyjppg" # Database name

enum sql_types {
#	INSERT,
	SELECT,
	UPDATEAKINA,
	UPDATESHUTOKO,
	DELETE,	
}

var sql_type = -1

var time
var username
func connectDB():
	var _error := database.connect("connection_established", self, "_execAll")
	_error = database.connect("authentication_error", self, "_authentication_error")
	_error = database.connect("connection_closed", self, "_close")	
	#Connection to the database
	_error = database.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [USER, PASSWORD, HOST, PORT, DATABASE])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _execAll():
	match sql_type:
		#sql_types.INSERT:
		#	_execInsert()
		sql_types.SELECT:
			_execSelect()
		sql_types.UPDATEAKINA:
			_execUpdateAkina()
		sql_types.UPDATESHUTOKO:
			_execUpdateShutoko()
		sql_types.DELETE:
			_execDelete()
			
#Insert, Select, Update & Delete : setup data & SQL
func _execSelect():
	
	var data = selectFromDB("BEGIN; SELECT * FROM test; COMMIT;")
	var return_data = ""
	
	for d in data:
		for n in d.size():
			return_data += str(d[n]) + "\t"
			print(d[n])
		return_data += "\n"
		
	#show_data.set_text(return_data)
	
func _execUpdateAkina():
	var data = [[str(time, username)]]
	updateToDB("BEGIN; UPDATE test SET " + '"scoreAkina"' + " = '%s' WHERE " + '"username"'+" = '%s'; COMMIT;", data)
func _execUpdateShutoko():
	var data = [[str(time, username)]]
	updateToDB("BEGIN; UPDATE test SET " + '"scoreShutoko"' + " = '%s' WHERE " + '"username"'+" = '%s'; COMMIT;", data)
	
func _execDelete():
	var data = [[$IDPlayer.get_text()]]
	deleteFromDB("BEGIN; DELETE FROM players WHERE id = %s; COMMIT;", data)
	

#Insert, Select, Update & Delete executes

func selectFromDB(sql:String) -> Array:
	var datas := database.execute(sql)
	var rows = datas[1].data_row
	
	database.close()
	
	return rows

func updateToDB(sql: String, data: Array):
	var _sql
	
	for d in data:
		_sql = sql % d
		database.execute(_sql)
		print(_sql)

	database.close()

func deleteFromDB(sql: String, data: Array):
	#var datas
	var _sql
	
	for d in data:
		_sql = sql % d
		database.execute(_sql)
		print(_sql)

	database.close()


func _on_RestartButton_pressed():
	var MapSettings= get_node("/root/GlobalVar")
	username=MapSettings.Username
	if MapSettings.AkinaPassed==true:
		sql_type = sql_types.UPDATESAKINA
		MapSettings.AkinaPassed=false
		time=MapSettings.AkinaTime
		connectDB()
	if MapSettings.ShutokoPassed==true:
		sql_type = sql_types.UPDATESHUTOKO
		MapSettings.ShutokoPassed=false
		time=MapSettings.ShutokoTime
		connectDB()
	
	
	get_tree().change_scene("res://Scenes/menus/StartMenu.tscn")
