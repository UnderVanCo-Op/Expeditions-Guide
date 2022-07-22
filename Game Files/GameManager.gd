extends Node2D
# This is GameManager.gd

export var ToolModeToggle := false	# toggle instantiating ways on click
var playerScene = preload("res://Objects/Player/Player.tscn")
var player
var isPMoving := false				# shows if the player is moving at the moment
var interp := 0.0					# (misc) interpolation value for Player movement
var StartPosP := Vector2.ZERO		# start position for the same interpolation
var EndPos := Vector2.ZERO			# end position for same also
var lastPTool = null				# ref to last points for Tool, for making sosedi, updates from Points
var PlayerPoint = null				# ref to Point on which Player is standing
var nextPPoint = null
var SaveMInst := SaveMaster.new()	# instance of a saving class (for paths only for now)

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
	# Paths work
	if(SaveMInst.DoesSaveExists()):
		print("GM: Save for paths exists, loading...")
		var _data = SaveMInst.Load_paths()
		if(!_data):
			push_error("GM: loaded null data from save paths")
			return
		for p in get_node("../Points").get_children():
			if(p.name in _data.keys()):				# if point is in JSON
				p.sosedi.append_array(_data[p.name])		# add in list
				print("GM: Loaded some sosed: ", _data[p.name])
	else:
		printerr("GM: no save exists, so no paths was loaded")
		
	# Other (to be done in future)


# For now only runs when finishing streching new way from Tool mode
func SaveGame() -> void:
	# Paths work
	var data := {}
	for p in get_node("../Points").get_children():
		data[p.name] = p.sosedi
		pass
	print("GM: data to save: ", data)
	SaveMInst.Save_paths(data)
	
	# Other (to be done in future)


# ---------- Other methods ------------------------------------------------------------------------------
