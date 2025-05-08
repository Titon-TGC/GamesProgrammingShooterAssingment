extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var sprite = $Sprite2D
@onready var deathParticles = preload("res://Scenes/DeathEffect.tscn")
@onready var flower = preload("res://Scenes/Flower.tscn")
@onready var tilemap = get_tree().get_first_node_in_group("Tilemap")
@onready var lilypad = preload("res://Scenes/Lilypad.tscn")
@onready var healthPickup = preload("res://Scenes/HealthPickup.tscn")
var deathSound = preload("res://Sounds/yay-6120.mp3")
var slapSound = preload("res://Sounds/slap-hurt-pain-sound-effect-262618.mp3")
var tileID = "TileID"
var speed = 50
var health = 100
var damage = 10
var isdead = false
var attackOnCooldown = false
var original_scale_x = 1
var facing_right = true

func _ready():
	scale.x = abs(scale.x)
	original_scale_x = scale.x
	facing_right = true

func _physics_process(delta: float) -> void:
	if $AnimationPlayer.current_animation == "Attack":
		return
	if isdead == false:
		var direction = (player.position - position).normalized()
		velocity = lerp(velocity, direction * speed, 8.5 * delta)
		move_and_slide()
		
	
		if velocity.x > 0.1:
			$PlayerDetector.scale.x = -1
			$AttackDetector.scale.x = -1
			$Sprite2D.flip_h = 1
			$Sprite2D.offset = Vector2(16, 0)
		elif velocity.x < -0.1:
			$PlayerDetector.scale.x = 1
			$AttackDetector.scale.x = 1
			$Sprite2D.flip_h = 0
			$Sprite2D.offset = Vector2(0, 0)
	
func hit(damage):
	health -= damage
	flash()
	if health <= 0:
		die()

func die():
	isdead = true
	get_tree().get_first_node_in_group("GameManager").points += 5
	var tile : Vector2 = tilemap.local_to_map(position)
	var tile_data : TileData = tilemap.get_cell_tile_data(tile)
	if tile_data:
		var tileData = tile_data.get_custom_data(tileID)
		if tileData == 2 or tileData == 3:
			var lilypadins = lilypad.instantiate()
			get_parent().add_child(lilypadins)
			lilypadins.global_position = global_position
		if tileData == 0 or tileData == 1:
			var flowerins = flower.instantiate()
			get_parent().add_child(flowerins)
			flowerins.global_position = global_position
	
	var effect = deathParticles.instantiate()
	effect.global_position = global_position
	get_parent().add_child(effect)
	SoundUtils.play_sound_at_position(deathSound, global_position, get_parent())
	FinalStats.treesFreed += 1
	
	var healthPickupChance = randi_range(1,5)
	if healthPickupChance == 1:
		var healthins = healthPickup.instantiate()
		get_parent().add_child(healthins)
		healthins.global_position = global_position
	
	queue_free()
	
func flash():
	sprite.modulate = Color.LIGHT_GREEN
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE

func attack():
	$AttackDetector.monitoring = true
	SoundUtils.play_sound_at_position(slapSound, global_position, get_parent().get_parent())

func end_attack():
	$AttackCooldown.start()
	attackOnCooldown = true
	$AttackDetector.monitoring = false
	$AnimationTree.set("parameters/conditions/Attack", 0)

#func start_walk():
	#$AnimationTree.set("parameters/conditions/Attack", 0)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if attackOnCooldown:
		return
	$AnimationTree.set("parameters/conditions/Attack", 1)


func _on_attack_detector_body_entered(body: Node2D) -> void:
	get_tree().get_first_node_in_group("Player").TakeDamage(damage)


func _on_attack_cooldown_timeout() -> void:
	attackOnCooldown = false
