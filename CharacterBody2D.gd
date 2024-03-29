extends CharacterBody2D


const SPEED = 65.0
const JUMP_VELOCITY = -200.0

enum STATES { IDLE = 0, DEAD, DAMAGED, ATTACKING}

@onready var p_HUD = get_tree().get_first_node_in_group("Hud")
@export var data = {
	"max_health": 100.0,
	"health": 100.0,
	"stamina": 50.0,
	"state": STATES.IDLE }
	
	
	
	
var inertia = Vector2()
var look_direction = Vector2.RIGHT
var attack_direction = Vector2.RIGHT

var slash_scene = preload("res://slash.tscn")


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_on = true


func _physics_process(delta):
	if not is_on_floor() and gravity_on:
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation(direction)
	move_and_slide()


@onready var anim = $AnimatedSprite2D
func update_animation(direction):
	anim.play("default")
	if direction != 0:
		anim.play("walk")
		anim.flip_h = direction < 0


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = Vector2(0.5, -20)


func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_death_box_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = Vector2(0.5, -20)


func _on_lava_body_entered(body):
	if body.is_in_group("player"):
		body.global_position = Vector2(0.5, -20)


func _on_portal_lvl_1_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://level_2.tscn")


func _on_treasure_body_entered(body):
	pass
