extends TileMapLayer

@export var score : int
var tileID = "TileID"


@export var noise_height_text : NoiseTexture2D
var noise : Noise
var width : int = 100
var height : int = 100
var source_id = 0
var water_atlas = Vector2i(1,1)
var land_atlas = Vector2i(1,0)

var refil_rate_multiplier = 1

func _ready():
	noise = noise_height_text.noise
	noise.seed = randi_range(0,100)
	generate_world()

func _physics_process(delta: float) -> void:
	$"../CanvasLayer/Panel/VBoxContainer/TilesLeftBar/TilesLeft".text = str(10000 - score) + "/10000"
	$"../CanvasLayer/Panel/VBoxContainer/TilesLeftBar".value = (10000 - score)
	
	if score == 10000:
		get_tree().get_first_node_in_group("GameManager").end_game()
	var tile : Vector2 = local_to_map($"../CharacterBody2D".position)
	var tile_data : TileData = get_cell_tile_data(tile)
	if tile_data:
		var tileDataValue = tile_data.get_custom_data(tileID)
			
		match tileDataValue:
			2: #Clean water
				$"../CharacterBody2D/Gun".refill_rate = 3 * refil_rate_multiplier
				if $"../CharacterBody2D/Gun".refill_timer.time_left <= 0:  # Check if timer is not running
					$"../CharacterBody2D/Gun".refill_timer.start()
			3: #Corrupted water
				$"../CharacterBody2D/Gun".refill_rate = 1 * refil_rate_multiplier
				if $"../CharacterBody2D/Gun".refill_timer.time_left <= 0:  # Check if timer is not running
					$"../CharacterBody2D/Gun".refill_timer.start()
			_:
				$"../CharacterBody2D/Gun".refill_timer.stop()
				
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_value = noise.get_noise_2d(x,y)
			if noise_value > 0.0:
				set_cell(Vector2(x,y), source_id, land_atlas, randi_range(1,3))
			elif noise_value < 0.0:
				set_cell(Vector2(x,y), source_id, water_atlas, randi_range(1,3))
