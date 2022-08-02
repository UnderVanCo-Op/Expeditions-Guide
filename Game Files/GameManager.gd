extends Node2D
# This is GameManager.gd

# warning-ignore-all:RETURN_VALUE_DISCARDED

export var ToolModeToggle := false	# toggle instantiating ways on click
var playerScene = preload("res://Objects/Player/Player.tscn")
var player

# inter variables
var isPMoving := false				# shows if the player is moving at the moment
var interp := 0.0					# (misc) interpolation value for Player movement
var StartPosP := Vector2.ZERO		# start position for the same interpolation
var EndPos := Vector2.ZERO			# end position for same also
var lastPTool = null				# ref to last points for Tool, for making sosedi, updates from Points
var PlayerPoint = null				# ref to Point on which Player is standing
var nextPPoint = null				# additional var for movement
var SaveMInst := SaveMaster.new()	# instance of a saving class (for paths only for now)
var PathsData := {}					# dict of adjacent matrix (on start has values from JSON)

# world-related variables
var time

# ---------- Starting methods ---------------------------------------------------------------------------
func _ready() -> void:
	
	PlayerPoint = get_node_or_null("../Points/Start")
	if(!PlayerPoint):
		push_error("GM_ERROR: No start in scene!")
	
	LoadGame()
	
	call_deferred("SignalConnector")
	call_deferred("StartGame")
	

func SignalConnector() -> void:
	var t = get_node_or_null("../Points")		# привязка к Точкам
	if(t):
		for p in t.get_children():
			p.connect("WayButPressed", self, "s_WayButPressed")	# signal connection
	else:
		push_error("GM_ERROR: failed to get Points node!")
	

func StartGame() -> void:
	player = playerScene.instance()
	get_parent().add_child(player)
	player.position = PlayerPoint.position
#	player.position = get_global_mouse_position()
	

# ---------- Processing methods -------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if(isPMoving):
		interp += delta * 0.7
		player.position = StartPosP.linear_interpolate(EndPos, interp)	# easy linear interpolation
		if(interp >= 1):
#			print("GM: Target reached, stopping movement")
			interp = 0.0		# just in case
			PlayerPoint = nextPPoint
			isPMoving = false
	

# ---------- Signals income methods----------------------------------------------------------------------
func s_WayButPressed(_point : StaticBody2D) -> void:
#	print("GM: signal received from ", _point)
	if(!isPMoving):
		if(_point == PlayerPoint):
			push_warning("GM_WARN: Can not move to the same Point")
			return
		if(_point.name in PlayerPoint.sosedi):
			print("GM: moving to the adjacent Point")
			interp = 0.0
			StartPosP = player.position
			EndPos = _point.position
			nextPPoint = _point
			isPMoving = true
#			print("GM: starting movement, StartPosP:", StartPosP, " EndPos:", EndPos)
		else:
			print("GM: Point is not a neighbour, can not move!!!")
			return
	else:
		print("GM: Player is already moving, wait!")


# ---------- Save, Load and Path-related methods --------------------------------------------------------
# Called in _ready()
func LoadGame() -> void:
	# Paths work (script part)
	if(SaveMInst.DoesSaveExists()):
		print("GM: Save for paths exists, loading...")
		PathsData.clear() 									# JIC
		var t  = SaveMInst.Load_paths()
		if(!t):
			push_error("GM: loaded null data from save paths")
			return
		PathsData = t as Dictionary
		for p in get_node("../Points").get_children():
			if(p.name in PathsData.keys()):					# if point is in JSON
				p.sosedi.append_array(PathsData[p.name])	# add each sosed to the point list
				
#				print("GM: Loaded some sosedi: ", PathsData[p.name])
#		print("GM: PathsData after loading all points:", PathsData)
	else:
		printerr("GM: no save exists, so no paths was loaded")
		
	# Other (to be done in future)

# Called automatically in SaveGame() if no argument is passed
func UpdatePathsD() -> void:
	var _data := {}
	for p in get_node("../Points").get_children():
		if(p.sosedi):
			_data[p.name] = p.sosedi
	
	PathsData = _data	# JIC


# For now only runs when finishing streching new way from Tool mode
func SaveGame(shouldUpdate := true) -> void:
	# Paths work
	if(shouldUpdate):
		UpdatePathsD()
#	print("GM: PathsData to save: ", PathsData)
	SaveMInst.Save_paths(PathsData)
	# Other (to be done in future)

# 
func CheckForExistingPath(_pathData : Array) -> bool:
	if(ToolModeToggle):		# additional check, j.i.c.
		if(PathsData.has(_pathData[0])):
			var t = PathsData[_pathData[0]]
			if(!t):
				print("GM: point is in PathsData, but it has no sosedis")
				return false
			for _p in t as Array:			# value (берём соседей)
				if(_p == _pathData[1]):		# если конкретная точка из соседей совпала
					print("\nGM: found adj point, path already exists! Maybe you forgot to reload? Anyway, deleting path and sosedis now...")
					
					# delete path
					var values : Array = PathsData.get(_pathData[0])	# берём соседей из словаря
					PathsData.erase(_pathData[0])		# удаляем key-value par из словаря
					values.erase(_pathData[1])			# удаляем нужного нам соседа
					PathsData[_pathData[0]] = values	# добавляем kv par обратно в словарь
					
					# повторяем для второй точки тоже самое
					values = PathsData.get(_pathData[1])	# берём соседей из словаря
					PathsData.erase(_pathData[1])			# удаляем key-value par из словаря
					values.erase(_pathData[0])				# удаляем нужного нам соседа
					PathsData[_pathData[1]] = values		# добавляем kv par обратно в словарь
					
					print("GM: sosedi from points were deleted! Saving game...")
					
					
					# удаляем саму линию из рантайма
					var p1 = get_node_or_null("../Points/" + str(_pathData[0]))
					var p2 = get_node_or_null("../Points/" + str(_pathData[1]))
					if(!p1 or !p2):
						printerr("GM: could not get both Points to delete line, return (true)")
						return true
					
					p1.sosedi.erase(p2.name)
					p2.sosedi.erase(p1.name)
					SaveGame(true)
					
					for l in get_node("../Lines").get_children():
						if((l.points[0] == p1.position and l.points[1] == p2.position) or (l.points[0] == p2.position and l.points[1] == p1.position)):	# into 1 side and another
							
#							print("GM: Line ", l, " is going to be deleted!")
							l.queue_free()
							
#							print("GM: Line also deleted!")
							return true
						pass
					printerr("GM: Line has not been found! (but anyway)")
					return true 	# JIC
			print("GM: path dont exist!")	# overly
			return false					# overly
		else:
			print("GM: such path has not been found!")
			return false
	else:
		print("GM: Exist check skipped bcs tool mode is off")
		return false

# ---------- Other methods ------------------------------------------------------------------------------


# ---------- Ending methods ------------------------------------------------------------------------------

func _exit_tree() -> void:
#	print("GM exit_tree reached!")
	SaveGame()		# update on quit
	pass
