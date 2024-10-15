extends CharacterBody2D

#@onready var sword = get_parent().get_node("")
@export var speed:float = 300.0
@export var jump_velocity:float = -400.0
@export var double_jump_velocity:float = -400.0
var has_double_jumped:bool = false 
@export var player_health:float = 30.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var animation_locked : bool = false 
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false 
@onready var timer : Timer = $Timer



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
	if Input.is_action_just_pressed("attack1"):
		attack1()
	if Input.is_action_just_pressed("left"):
		$Sword.scale.x = abs($Sword.scale.x)* -1
	if Input.is_action_just_pressed("right"):
		$Sword.scale.x = abs($Sword.scale.x)* 1
	
		

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
	if (["jump_End","jump_Start","attack"].has(animated_sprite.animation)):
		animation_locked = false 
		$Sword/CollisionShape2D.disabled = true
				
		
func attack1():
	animated_sprite.play("attack")
	animation_locked = true 
	$Sword/CollisionShape2D.disabled = false 

func check_hits():
	var hitbox_areas =$player_damage_area.get_overlapping_areas()
	var damage : int
	if hitbox_areas :
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() == $CharacterBody2D/Enemy_attack :
			damage = Global.crow_damage
			player_health -= damage
			if player_health <= 0:
				animated_sprite.play("dead")
				$Timer.start(0.5)
		
func _on_timer_timeout() -> void:
	get_parent().queue_free()
