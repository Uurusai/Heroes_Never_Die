extends AnimatedSprite2D
@onready var coin_meter = $coin_meter

func _on_coin_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("coin_collector") and Global.coin_count < Global.coin_max :
		Global.coin_count += 1
		print(Global.coin_count)
		queue_free()

	
