extends CharacterBody2D

@export var speed = 400
@export var maxhealth = 100
@export var currentHealth = 100
@export var dodge_speed = 1000
@onready var healthText = $"../CanvasLayer/Panel/VBoxContainer/Health"
@onready var gamemanager = get_tree().get_first_node_in_group("GameManager")
var can_dodge = true
@export var isdashing = false
var last_facing_direction = Vector2(0, -1)

func _physics_process(delta):
	$"../CanvasLayer/Panel/PlayerStats/HealthBar".max_value = maxhealth
	$"../CanvasLayer/Panel/PlayerStats/HealthBar".value = currentHealth
	$"../CanvasLayer/Panel/PlayerStats/HealthBar/Health".text = str(currentHealth) + "/" + str(maxhealth)
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	var idle = !velocity
	if !idle:
		last_facing_direction = velocity.normalized()
	move_and_slide()
	
	$AnimationTree.set("parameters/conditions/Idle", idle)
	$AnimationTree.set("parameters/conditions/Walk", !idle)
	
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	$Sprite2D.flip_h = to_mouse.x < 0
	
	if Input.is_action_just_pressed("dodge") and can_dodge:
		$AnimationTree.set("parameters/conditions/Dodge", !idle)
		$Dodge.play()
		can_dodge = false
		#velocity = input_direction.normalized() * dodge_speed
		$DodgeCooldown.start()
		
func TakeDamage(damage):
	$Hurt.play()
	currentHealth -= damage
	print("Took ", damage)
	if currentHealth <= 0:
		die()

func Heal(healAmount):
	$Potion.play()
	currentHealth += healAmount
	if currentHealth >= maxhealth:
		currentHealth = maxhealth

func die():
	FinalStats.wavesSurvived = gamemanager.waveCounter
	FinalStats.upgradesPurchased = gamemanager.upgradesBought
	get_tree().change_scene_to_file("res://Scenes/DeathScene.tscn")

func _on_dodge_cooldown_timeout() -> void:
	can_dodge = true


func finishDodge():
	$AnimationTree.set("parameters/conditions/Dodge", 0)
