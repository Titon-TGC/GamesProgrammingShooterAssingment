extends Node2D

const SPEED: int = 300
var tileID = "TileID"
@onready var timeSinceShot = $Timer
@onready var tilemap = get_tree().get_first_node_in_group("Tilemap")
@onready var gun = get_tree().get_first_node_in_group("Gun")

func _process(delta):
	position += transform.x * SPEED * delta * timeSinceShot.time_left

func _physics_process(delta: float) -> void:
	if tilemap != null:
		var tile : Vector2 = tilemap.local_to_map(position)
		var tile_data : TileData = tilemap.get_cell_tile_data(tile)
		if tile_data:
			var tileData = tile_data.get_custom_data(tileID)
			if tileData == 1:
				tilemap.set_cell(tile, 0, Vector2i(0, 0), randi_range(1,3))
				tilemap.score += 1
			if tileData == 3:
				tilemap.set_cell(tile, 0, Vector2i(0, 1), randi_range(1,3))
				tilemap.score += 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	explode()
	await 2
	queue_free()
	
func explode() -> void:
	if tilemap == null:
		return
	for cell in tilemap.get_used_cells():
		var local_position = tilemap.map_to_local(cell)
		var explosion_center = $ExplosionRadius/CollisionShape2D.global_position
		var radius = $ExplosionRadius/CollisionShape2D.shape.radius
		if Geometry2D.is_point_in_circle(tilemap.map_to_local(cell), explosion_center, radius):
			
			var tile_data : TileData = tilemap.get_cell_tile_data(cell)
			if tile_data: 
				var tileData = tile_data.get_custom_data(tileID)
				if tileData == 1:
					tilemap.set_cell(cell, 0, Vector2i(0, 0))
					tilemap.score += 1
				if tileData == 3:
					tilemap.set_cell(cell, 0, Vector2i(0, 1))
					tilemap.score += 1
	
	#var pop = preload("res://Scenes/BubbleDebris.tscn").instantiate()
	#pop.global_position = global_position
	#get_parent().add_child(pop)
					
	for enemy in $ExplosionRadius.get_overlapping_bodies():
		if enemy.is_in_group("Enemy"):
			enemy.hit(gun.damage)


func _on_bullet_area_body_entered(body: Node2D) -> void:
	for enemy in $BulletArea.get_overlapping_bodies():
		if enemy.is_in_group("Enemy"):
			enemy.hit(gun.damage)
