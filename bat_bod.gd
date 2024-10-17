extends CharacterBody2D
# Variables for movement and range
var screen_size = get_viewport_rect().size
var animation_locked : bool = false
var found_player : bool = false
var bat_health : float = 20 
@export var speed: float = 100.0
@onready var bat_sprite : AnimatedSprite2D = $BatSprite2D

var direction = Vector2(1, 1)  # Moving diagonally by default

func _ready():
	Global.bat_bod = self 

func _physics_process(delta):
	if animation_locked == true :
		bat_sprite.play("idle")

	if found_player :
		move(delta)
				
	
func _on_bat_detection_area_body_entered(body: Node2D) -> void:
	if body == Global.player_body:
		bat_sprite.play("formation")
		

func _on_bat_sprite_2d_animation_finished() -> void:
	if (["formation"].has(bat_sprite.animation)):
		animation_locked = true
	if (["idle_to_fly"].has(bat_sprite.animation)):
		bat_sprite.play("fly")
	if (["attack"].has(bat_sprite.animation)):
		$bat_attack_area/CollisionShape2D.disabled = true
		
func _on_bat_activation_body_entered(body: Node2D) -> void:
	if body == Global.player_body :
		found_player = true
		animation_locked  = false 
		bat_sprite.play("idle_to_fly")
func move(delta):
	var dir_to_player = position.direction_to(Global.player_body.position) 
	velocity.x = dir_to_player.x * speed*delta
	flip()
	move_and_slide()


func choose(array):
	array.shuffle()
	return array.front()
	
func _on_bat_timer_timeout() -> void:
	$bat_timer.wait_time= choose([1,1.5,2])
	direction = choose([Vector2.RIGHT, Vector2.LEFT])
func flip():
	if direction.x>0 :
		bat_sprite.flip_h = false
		$bat_attack_area.position.x = 18
	elif direction.x < 0 :
		bat_sprite.flip_h = true
		$bat_attack_area.position.x = 90
		
func _on_bat_attack_area_body_entered(body: Node2D) -> void:
	if body == Global.player_body :
		bat_sprite.play("bite")
		$bat_attack_area/attack_cooldown.start(1.5)

func _on_attack_cooldown_timeout() -> void:
	$bat_attack_area/CollisionShape2D.disabled = false
	
func _on_bat_damage_area_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.player_body and area.is_in_group("player_hitter"):
		bat_health -= Global.player_damage
		print(bat_health)
		if bat_health <= 0 :
			bat_sprite.play("die")
			$bat_damage_area/death_timer.start(2)
			
func _on_death_timer_timeout() -> void:
	get_parent().queue_free()
