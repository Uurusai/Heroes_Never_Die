extends CharacterBody2D
var speed = 1
@export var health: float  = 20
var facing_right = true
@onready var animated_sprite: AnimatedSprite2D = $crow_sprite



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	velocity.x = speed 
	move_and_slide()	
	check_hits()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x)* -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed)*-1
	
func check_hits():
	var hitbox_areas =$Enemy_attack.get_overlapping_areas()
	var hitbox = hitbox_areas.front()
	if ( hitbox.get_path() == $player_damage_area) :
		print("CharacterBody2D detected")
		animated_sprite.play("attack")
	else:
		print("Not CharacterBody2D, it's ", hitbox.get_path())
