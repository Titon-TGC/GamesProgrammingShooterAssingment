extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var pickupSound = preload("res://Sounds/health-pickup-6860.mp3")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.Heal(10)
		queue_free()
