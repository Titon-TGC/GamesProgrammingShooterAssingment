extends Node2D

const SPEED: int = 300
var washedData = "Washed"

func _process(delta):
	position += transform.x * SPEED * delta

func _physics_process(delta: float) -> void:
	var tilemap = get_tree().get_first_node_in_group("Tilemap")
	var tile : Vector2 = tilemap.local_to_map(position)
	var tile_data : TileData = tilemap.get_cell_tile_data(tile)
	var atlas_coord : Vector2i = Vector2i(0,0)
	if tile_data:
		var washed = tile_data.get_custom_data(washedData)
		if washed == false:
			tilemap.set_cell(tile, 1, atlas_coord)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
