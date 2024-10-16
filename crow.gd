extends CharacterBody2D

@export var speed = 0
@export var health: float = 20
var player = Global.player_body

@onready var animated_sprite: AnimatedSprite2D = $crow_sprite
var direction: Vector2 = Vector2.ZERO 


func _ready():
	Global.crow = self

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	move()
	move_and_slide()

	if !$RayCast2D.is_colliding():
		if direction.x > 0:
			velocity = direction * speed * 1
		elif direction.x < 0 :
			velocity = direction * speed * -1
		flip()		
				
func flip():
	if direction.x>0 :
		animated_sprite.flip_h = false
		$Enemy_attack.scale.x = abs($Enemy_attack.scale.x)*1 
		$RayCast2D.scale.x = abs($RayCast2D.scale.x)*1
	elif direction.x <0 :
		animated_sprite.flip_h = true 
		$Enemy_attack.scale.x = abs($Enemy_attack.scale.x)*-1 
		$RayCast2D.scale.x = abs($RayCast2D.scale.x)*-1 

func choose(array):
	array.shuffle()
	return array.front()

func move():
	velocity = direction*speed
	flip()
	

func _on_crow_timer_timeout() -> void:
	$crow_timer.wait_time = choose([1,1.5,2])
	direction = choose([Vector2.RIGHT, Vector2.LEFT])
				

func _on_crow_sprite_animation_finished() -> void:
	if (["attack"].has(animated_sprite.animation)):
		$Enemy_attack/CollisionShape2D.disabled = true

	

func _on_enemy_attack_body_entered(body: Node2D) -> void:
	if body == Global.player_body:
		animated_sprite.play("attack")
		$Enemy_attack/attack_timer.start(1.5)
	
func _on_attack_timer_timeout() -> void:
	$Enemy_attack/CollisionShape2D.disabled = false
