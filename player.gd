extends CharacterBody2D


@export var speed:float = 300.0
@export var jump_velocity:float = -400.0
@export var double_jump_velocity:float = -400.0
var has_double_jumped:bool = false 
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var animation_locked : bool = false 
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true 
	else:
		has_double_jumped = false 
		if was_in_air :
			land()
		was_in_air = false 

	# Handle jump.
	if Input.is_action_just_pressed("jump") :
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			double_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right","up", "down")
	if direction && animated_sprite.animation != "jump_End" :
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	update_animation()
	update_facing_direction()
	move_and_slide()

func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
func update_facing_direction ():
	if direction.x>0 :
		animated_sprite.flip_h = false 
	elif direction.x <0 :
		animated_sprite.flip_h = true 
func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_Start")
	animation_locked = true 
func land():
	animated_sprite.play("jump_End")
	animation_locked = true

func double_jump():
	velocity.y = double_jump_velocity
	animated_sprite.play("jump_Start")
	has_double_jumped = true 
	animation_locked = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if (["jump_End","jump_Start"].has(animated_sprite.animation)):
		animation_locked = false 
