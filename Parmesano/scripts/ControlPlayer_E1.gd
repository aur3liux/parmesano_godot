extends KinematicBody2D

var player= Vector2()
var VELOCITY = 0
const GRAVITY = 1000
const JUMP_POWER = -500
var sentido = 0 #indica si el joystick esta suelto o presionado hacia algun lado
enum ESTADO{IDLE, IMPULSANDO, SALTANDO, FRENANDO, DESLIZANDO}
var state = 0 #indica cual de los estados está activo

onready var joystick = get_tree().get_nodes_in_group("control")[0].get_parent().get_node("joystick/boton")
onready var parmesano = get_tree().get_nodes_in_group("parmesano")[0].get_parent().get_node("Parmesano/player")
onready var stateMachine = get_tree().get_nodes_in_group("parmesano")[0].get_parent().get_node("Parmesano/stateMachine").get("parameters/playback")

func _physics_process(delta):
	player.x = 0
	#JOSTICK suelto
	if joystick.get_value().x == 0:
		VELOCITY = 0
		sentido = 0
		state=ESTADO.IDLE
		stateMachine.travel("idle")
	else:	
		#JOSTICK a la derecha		
		if joystick.get_value().x > 0.5:
			parmesano.flip_h = false
			sentido = 1
			if state == ESTADO.FRENANDO:
				VELOCITY = 0
				stateMachine.travel("frenando")
			else:
				stateMachine.travel("deslizando")
				VELOCITY = 200
		#JOSTICK a la izquierda
		elif joystick.get_value().x < -0.5:
			parmesano.flip_h = true
			sentido = -1
			if state == ESTADO.FRENANDO:
				VELOCITY = 0		
				stateMachine.travel("frenando")
			else:
				VELOCITY = 200
				stateMachine.travel("deslizando")
	#PERSONAJE pisando el piso
	if is_on_floor():
		if Input.is_action_just_pressed("saltar"):
			VELOCITY = 0
			state=ESTADO.SALTANDO
			stateMachine.travel("saltando")
			player.y = JUMP_POWER
			VELOCITY = 100
	
		#Presionando el boton de frenar
		if Input.is_action_just_pressed("frenar"):
			VELOCITY = 0
			state=ESTADO.FRENANDO
			stateMachine.travel("frenando")
		#Soltando el boton de frenar
		if Input.is_action_just_released("frenar"):
			VELOCITY = 0
			state=ESTADO.IDLE
			stateMachine.travel("idle")
		#Presionando boton de Impulsar y no se encuentre en reposo
		if Input.is_action_pressed("impulsar") && sentido!=0:
			VELOCITY = 300
			state=ESTADO.IMPULSANDO
			stateMachine.travel("impulsando")
		
	player.x += VELOCITY * sentido
	player.y += GRAVITY * delta
	move_and_slide(player, Vector2(0,-1))

