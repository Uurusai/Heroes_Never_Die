extends Node
class_name Damageable  

@onready var crow_sprite: AnimatedSprite2D = $"../crow_sprite"
@export var health: float  = 20
@onready var timer = $Timer
	
# Signal handlers for the damageable area
func _on_DamageableArea_body_entered(body):
	if body.is_in_group("damage_sources"):
		hit(body.damage)

func _on_NonDamageableArea_body_entered(body):
	print("Entered non-damageable area")
	
func hit (damage:int):
	health -= damage
	crow_sprite.play("hurt")
			
	if (health<=0):
		crow_sprite.play("die")
		timer.start()

func _on_timer_timeout() -> void:
	get_parent().queue_free()
