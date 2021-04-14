extends PathFollow2D

export var runSpeed = 70

func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
