extends Area2D

@export var damage:int = 10
@onready var crow_sprite: AnimatedSprite2D = $CharacterBody2D/crow_sprite


func _ready():
	monitoring = true
	 
func _on_body_entered(body: Node2D) :
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage)
			
	
