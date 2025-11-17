extends Area2D

@export var speed: int

var screen_size
var bullet = preload("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _process_walking(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _process_gun():
	if not Input.is_action_pressed("aim"):
		$GunRotation/Gun.visible = false
		return
	$GunRotation/Gun.visible = true
	var mouse_pos = get_viewport().get_mouse_position()
	$GunRotation.look_at(mouse_pos)
	if mouse_pos.x > $GunRotation.global_position.x:
		$GunRotation.flip_v = false
	else:
		$GunRotation.flip_v = true

	if Input.is_action_just_pressed("shoot"):
		$GunRotation/AudioStreamPlayer2D.play()
		var b = bullet.instantiate()
		b.velocity = $GunRotation/BulletSpawner.global_position.direction_to(mouse_pos)
		b.global_position = $GunRotation/BulletSpawner.global_position
		b.global_rotation = $GunRotation/BulletSpawner.global_rotation
		
		get_parent().get_node("BulletContainer").add_child(b)


func _process_user_input(delta):
	_process_walking(delta)
	_process_gun()

func _process(delta):
	if is_multiplayer_authority():
		_process_user_input(delta)
	
