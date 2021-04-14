extends KinematicBody2D

var player= Vector2()
var VELOCITY = 0
const GRAVITY = 600
const JUMP_POWER = -600
var sentido = 0 #indica si el joystick esta suelto o presionado hacia algun lado
#            0        1          2         3         4
enum ESTADO{IDLE, IMPULSANDO, SALTANDO, FRENANDO, DESLIZANDO}
var state = 0 #indica cual de los estados est� activo

onready var joystick = get_tree().get_nodes_in_group("control")[0].get_parent().get_node("joystick/boton")
onready var parmesano = get_tree().get_nodes_in_group("parmesano")[0].get_parent().get_node("Parmesano/player")
onready var stateMachine = get_tree().get_nodes_in_group("parmesano")[0].get_parent().get_node("Parmesano/stateMachine").get("parameters/playback")


func _physics_process(delta):
	player.x = 0
	#PERSONAJE pisando el piso
	if is_on_floor():
		get_tree().get_nodes_in_group("estado")[0].text = "En el piso"
		#estado_text.text = state
		if joystick.get_value().x == 0:  #JOSTICK suelto
			if Input.is_action_just_pressed("saltar"):
				setSaltar()
			else:
				setIdle()
		if joystick.get_value().x > 0.5:
			parmesano.flip_h = false
			sentido = 1
			setAvanzar()
		if joystick.get_value().x < -0.5:
			parmesano.flip_h = true
			sentido = -1
			setAvanzar()
		#Presionando el boton de frenar
		if Input.is_action_just_pressed("frenar"):
			setFrenar()	
		if Input.is_action_just_released("frenar"):
			setIdle()	
		if Input.is_action_just_pressed("saltar"):
			setSaltar()
		if Input.is_action_just_released("saltar"):
				setAvanzar()
		#end else
	#end if is_on_floor
	else: #no está en el piso
		get_tree().get_nodes_in_group("estado")[0].text = "En el aire"
		state = ESTADO.SALTANDO
		#JOSTICK a la derecha	
		if joystick.get_value().x > 0.5:
			parmesano.flip_h = false
			sentido = 1	
			VELOCITY = 200
		if joystick.get_value().x < -0.5:
			parmesano.flip_h = true
			sentido = -1
			VELOCITY = 200
	#end no esta en el suelo
	if state != ESTADO.FRENANDO:
		player.x += VELOCITY * sentido
	player.y += GRAVITY * delta
	player = move_and_slide(player, Vector2(0,-1))

func setIdle():
	VELOCITY = 0
	state=ESTADO.IDLE
	stateMachine.travel("idle")
	
func setSaltar():
	state=ESTADO.SALTANDO
	stateMachine.travel("saltando")
	player.y = JUMP_POWER
	VELOCITY = 100

func setFrenar():
	VELOCITY = 0
	state=ESTADO.FRENANDO
	stateMachine.travel("frenando")

func setAvanzar():
	if state == ESTADO.FRENANDO:
		VELOCITY = 0
		state=ESTADO.FRENANDO
		stateMachine.travel("frenando")
	else:
		VELOCITY = 400
		state=ESTADO.IMPULSANDO
		stateMachine.travel("impulsando")
