extends Node2D
# This is GameManager.gd

export var ToolModeToggle := true	# toggle instantiating ways on click
var playerScene = preload("res://Objects/Player/Player.tscn")
var player
var isPMoving := false				# shows if the player is moving at the moment
var interp := 0.0					# (misc) interpolation value for Player movement
var StartPosP := Vector2.ZERO		# start position for the same interpolation
var EndPos := Vector2.ZERO			# end position for same also
var lastPTool = null				# ref to last points for Tool, for making sosedi, updates from Points
var PlayerPoint = null				# ref to Point on which Player is standing
var nextPPoint = null				# additional var for movement
var SaveMInst := SaveMaster.new()	# instance of a saving class (for paths only for now)
var ParList := []					# only for runtime purposes, saves 2 pos-s (start and end of each Path) for fast checking

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
			print("GM: Target reached, stopping movement")
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
			print("GM: starting movement, StartPosP:", StartPosP, " EndPos:", EndPos)
		else:
			print("GM: Point is not a neighbour, can not move!!!")
			return
	else:
		print("GM: Player is already moving, wait!")


# ---------- Save and Load methods ----------------------------------------------------------------------
# Called in _ready
func LoadGame() -> void:
	# Paths work (script part)
	if(SaveMInst.DoesSaveExists()):
		print("GM: Save for paths exists, loading...")
		var _data = SaveMInst.Load_paths()
		if(!_data):
			push_error("GM: loaded null data from save paths")
			return
		for p in get_node("../Points").get_children():
			if(p.name in _data.keys()):				# if point is in JSON
				p.sosedi.append_array(_data[p.name])		# add sosedi (list) in list
				print("GM: Loaded some sosedi: ", _data[p.name])
				
				# Downlying: Parlist fulling
				for sosed in _data[p.name] as Array:	# for по всем значениям массива для этого ключа (по соседям)
					var _adjp = get_node_or_null("../Points/" + str(sosed))	# load sosed
					print("adjp path: ../Points/" + str(sosed))
					if(!_adjp):
						printerr("GM_LOAD: could not get adjacent point from save, did you messed up with file paths?)")
						return
					
					if([p.position, _adjp.position] in ParList or [_adjp.position, p.position] in ParList):
	#					print("PL: this way is already on the map, skipping...")
						continue	# (for next adjpoint of this point)
					else: 	
						ParList.append([p.position, _adjp.position])
	else:
		printerr("GM: no save exists, so no paths was loaded")
		
	# Other (to be done in future)


# For now only runs when finishing streching new way from Tool mode
func SaveGame() -> void:
	# Paths work
	var data := {}
	for p in get_node("../Points").get_children():
		if(p.sosedi):
			data[p.name] = p.sosedi
	print("GM: data to save: ", data)
	SaveMInst.Save_paths(data)
	get_tree().reload_current_scene()
	# Other (to be done in future)


# ---------- Other methods ------------------------------------------------------------------------------
func CheckForExistingPath(_pathData : Array) -> bool:
	if(ToolModeToggle):		# additional check, j.i.c.
		var one = ParList.find(_pathData)
		var two = ParList.find(_pathData.invert())
		if(one != -1 or two != -1):
			print("GM: this way is already on the map, deleting...")
			for l in get_node("../Lines").get_children():
				if((l.points[0] == _pathData[0] and l.points[1] == _pathData[1]) or (l.points[0] == _pathData[1] and l.points[1] == _pathData[0])):	# into 1 side and another
					
					l.queue_free()
					print("GM: Path deleted! Saving game...")
					
					if(one != -1 ):
						ParList.remove(one)
					else:
						ParList.remove(two)
					call_deferred("SaveGame")
					return true
			push_error("GM_ERROR: Path in ParList, but no Line node was found!")
			return true
		else:
			ParList.append(_pathData)
			return false
	else:
		return false
	
