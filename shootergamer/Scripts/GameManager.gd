extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
@export var waveCounter = 0
@onready var waveText = $"../CanvasLayer/Panel/TimerAndWaveCounter/Wave"
@export var points : int
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var gun = get_tree().get_first_node_in_group("Gun")
@onready var tilemap = get_tree().get_first_node_in_group("Tilemap")

var failBuySound = preload("res://Sounds/arcade-ui-4-229502.mp3")
var successBuySound = preload("res://Sounds/arcade-ui-1-229498.mp3")
@onready var stopwatch = $"../Stopwatch"

var healthStacks : int
var damageStacks : int
var ammoStacks : int
var radiusStacks : int
var speedStacks : int

var healthPrice = 10
var damagePrice = 10
var ammoPrice = 10
var radiusPrice = 10
var speedPrice = 10

var upgradesBought : int

func _ready() -> void:
	$"../CharacterBody2D/Gun".ammo = 100
	FinalStats.treesFreed = 0
	FinalStats.upgradesPurchased = 0
	FinalStats.wavesSurvived = 0

func end_game():
	FinalStats.wavesSurvived = waveCounter
	FinalStats.upgradesPurchased = upgradesBought
	FinalStats.timeTaken = stopwatch.time_to_string()
	get_tree().change_scene_to_file("res://Scenes/EndScene.tscn")

func _physics_process(delta: float) -> void:
	$"../CanvasLayer/Panel/TimerAndWaveCounter/Timer".text = stopwatch.time_to_string()
	$"../CanvasLayer/Panel/VBoxContainer/Points".text = " Points: " + str(points)

func _on_spawn_timer_timeout() -> void:
	waveCounter += 1
	waveText.text = " Wave: " + str(waveCounter)
	var enemySpawnCount = waveCounter * 5
	if get_tree().get_nodes_in_group("Enemy").size() < enemySpawnCount:
		for x in enemySpawnCount:
			await get_tree().create_timer(1).timeout
			spawn_enemies()

func spawn_enemies():
	var enemyins = enemy.instantiate()
	add_child(enemyins)
	enemyins.position = $SpawnLocation.position
	var nodes = get_tree().get_nodes_in_group("Spawn")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	$SpawnLocation.position = position
	

func _on_health_pressed() -> void:
	if points >= healthPrice:
		points -= healthPrice
		player.maxhealth += 10
		healthStacks += 1
		healthPrice += healthStacks * 5
		upgradesBought += 1
		SoundUtils.play_sound_at_position(successBuySound, global_position, get_parent())
		$"../CanvasLayer/Panel/UpgradeMenu/Health/Label".text = "+" + str(healthStacks * 10)
		$"../CanvasLayer/Panel/UpgradeMenu/Health/Label2".text = str(healthPrice)
	else:
		SoundUtils.play_sound_at_position(failBuySound, global_position, get_parent())

func _on_damage_pressed() -> void:
	if points >= damagePrice:
		points -= damagePrice
		gun.damage += 10
		damageStacks += 1
		damagePrice += damageStacks * 5
		upgradesBought += 1
		SoundUtils.play_sound_at_position(successBuySound, global_position, get_parent())
		$"../CanvasLayer/Panel/UpgradeMenu/Damage/Label".text = "+" + str(damageStacks * 10)
		$"../CanvasLayer/Panel/UpgradeMenu/Damage/Label2".text = str(damagePrice)
	else:
		SoundUtils.play_sound_at_position(failBuySound, global_position, get_parent())


func _on_ammo_pressed() -> void:
	if points >= ammoPrice:
		points -= ammoPrice
		tilemap.refil_rate_multiplier += 1
		ammoStacks += 1
		ammoPrice += ammoStacks * 5
		upgradesBought += 1
		SoundUtils.play_sound_at_position(successBuySound, global_position, get_parent())
		$"../CanvasLayer/Panel/UpgradeMenu/Ammo/Label".text = "+" + str(ammoStacks)
		$"../CanvasLayer/Panel/UpgradeMenu/Ammo/Label2".text = str(ammoPrice)
	else:
		SoundUtils.play_sound_at_position(failBuySound, global_position, get_parent())


func _on_radius_pressed() -> void:
	if points >= radiusPrice:
		points -= radiusPrice
		gun.explosionRadius += 10
		radiusStacks += 1
		radiusPrice += radiusStacks * 5
		upgradesBought += 1
		SoundUtils.play_sound_at_position(successBuySound, global_position, get_parent())
		$"../CanvasLayer/Panel/UpgradeMenu/Radius/Label".text = "+" + str(radiusStacks * 10)
		$"../CanvasLayer/Panel/UpgradeMenu/Radius/Label2".text = str(radiusPrice)
	else:
		SoundUtils.play_sound_at_position(failBuySound, global_position, get_parent())


func _on_speed_pressed() -> void:
	if points >= speedPrice:
		points -= speedPrice
		player.speed += 50
		speedStacks += 1
		speedPrice += speedStacks * 5
		upgradesBought += 1
		SoundUtils.play_sound_at_position(successBuySound, global_position, get_parent())
		$"../CanvasLayer/Panel/UpgradeMenu/Speed/Label".text = "+" + str(speedStacks * 50)
		$"../CanvasLayer/Panel/UpgradeMenu/Speed/Label2".text = str(speedPrice)
	else:
		SoundUtils.play_sound_at_position(failBuySound, global_position, get_parent())
