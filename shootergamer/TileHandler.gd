extends TileMapLayer

#var washedData = "Washed"

#func _physics_process(delta):
	#if(Input.is_action_just_pressed("click")):
		#var mouse_pos : Vector2 = get_global_mouse_position()
		#var tile_mouse_pos : Vector2i = local_to_map(mouse_pos)
		#var source_id : int = 1
		#var atlas_coord : Vector2i = Vector2i(1,0)
		#var tile_data : TileData = get_cell_tile_data(tile_mouse_pos)
		
		#if tile_data:
			#var washed = tile_data.get_custom_data(washedData)
			#if washed:
				#set_cell(tile_mouse_pos, source_id, atlas_coord)
