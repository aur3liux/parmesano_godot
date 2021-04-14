extends TouchScreenButton

var radio = Vector2(24,24)
var limite= 24
var marcha = -1
var volver = 20
var limite2 = 10

func _physics_process(delta):
	if marcha == -1:
		var pos_difference = (Vector2(0, 0) - radio) - position
		position += pos_difference * volver * delta
		
func get_button_pos():
	return position + radio
	
func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):		
		var distCentre = (event.position - get_parent().global_position).length()				
		if distCentre <= limite * global_scale.x or event.get_index() == marcha:
			set_global_position(event.position - radio * global_scale)
			if get_button_pos().length() > limite:
				set_position( get_button_pos().normalized() * limite - radio)	
			marcha = event.get_index()	
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == marcha:
		marcha = -1	
	
func get_value():
	if get_button_pos().length() > limite2:
		return get_button_pos().normalized()
	return Vector2(0, 0)
