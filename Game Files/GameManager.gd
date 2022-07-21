extends Node2D
# This is GameManager.gd

var playerScene = preload("res://Objects/Player/Player.tscn")
var player
var isPMoving := false			# shows if the player is moving at the moment
var interp := 0.0				# interpolation value for Player movement
var StartPosP := Vector2.ZERO	# start position for the same interpolation
var EndPos := Vector2.ZERO		# end position for same also
var lastP = null				# ref to last points for Tool, for making sosedi, updates from Points



# ---------- Starting methods ---------------------------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("SignalConnector")
	call_deferred("StartGame")
	pass # Replace with function body.


func SignalConnector() -> void:
	var t = get_node_or_null("../Points")		# привязка к Точкам
	if(t):
		for p in t.get_children():
			p.connect("WayButPressed", self, "s_WayButPressed")	# signal connection
	else:
		push_error("GM_ERROR: failed to get Points node!")
	pass


func StartGame() -> void:
	player = playerScene.instance()
	get_parent().add_child(player)
	player.position = get_global_mouse_position()
	pass



# ---------- Processing methods -------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if(isPMoving):
		interp += delta * 0.7
		player.position = StartPosP.linear_interpolate(EndPos, interp)
		if(interp >= 1):
			print("Target reached, stopping movement")
			interp = 0.0		# just in case
			isPMoving = false
	pass



# ---------- Other methods ------------------------------------------------------------------------------
func s_WayButPressed(Point : StaticBody2D) -> void:
	print("GM: signal received from ", Point)
	
	interp = 0.0
	StartPosP = player.position
	EndPos = Point.position
	isPMoving = true
	print("GM: starting movement, StartPosP:", StartPosP, " EndPos:", EndPos)
	
	pass


