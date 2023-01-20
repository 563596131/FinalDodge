class_name Player
extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var lq = false
var hp = 10
var ss = false
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$Sprite.visible = false


func _process(delta):
	$ProgressBar.value = hp
	$ProgressBar.max_value = 10
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("space"):			# press space to use protect cover
		if !lq:
			lq = true
			$Sprite.visible = true
			$CollisionShape2D.disabled = true
			$Timer.start(3)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func start(pos):
	position = pos
	hp = 10
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	if !ss:
		if hp == 0 :
			hide() # player hide after hit
			emit_signal("hit")
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			ss = true
			hp -= 1



func _on_Timer_timeout():
	$Sprite.visible = false
	$CollisionShape2D.disabled = false
	$Timer2.start(5)
	pass # Replace with function body.


func _on_Timer2_timeout():
	lq = false
	pass # Replace with function body.


func _on_Timer3_timeout():
	ss = false
	pass # Replace with function body.
