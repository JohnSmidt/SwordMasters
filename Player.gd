extends Area2D

@export var speed        : int = 400 # How fast the player will move (pixels/sec).
@export var stamina      : float = 100
@export var health       : float = 100
@export var fp           : float = 100 # Fighting power, for special moves?
@export var dodgeTimeMax : float = 100
@export var dodgeSpeed   : int = 800
@export var dodgeStaminaExpense : int = 30

var staminaRegen : int = 15

var isDodging : bool = false
var isAttacking : bool = false
var screen_size # Size of the game window.
var velocity : Vector2 = Vector2.ZERO # The player's movement vector.
var dodgeTime : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isDodging:
		dodge(delta)
	elif isAttacking:
		attack(delta) # This will need a weapon
	else:
		checkBasicMovement()
		checkDodge()
		checkAttack()
	if stamina < 100:
		stamina += delta * staminaRegen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

###############################
#  CHECKS
###############################
#region Checks
func checkDodge():
	if Input.is_action_just_pressed("dodge") && !isDodging:
		if velocity.x != 0 || velocity.y != 0:
				if stamina > 0: # Exhaustive: can reach below 0, making the player wait for recharge
					stamina -= dodgeStaminaExpense
					dodgeTime = dodgeTimeMax
					isDodging = true

func checkBasicMovement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func checkAttack():
	pass
#endregion

###############################
#  Events
###############################
#region Events
func dodge(delta):
	velocity = velocity.normalized() * dodgeSpeed
	dodgeTime -= delta
	if dodgeTime <= 0:
		isDodging = false

func attack(delta):
	pass
#endregion
