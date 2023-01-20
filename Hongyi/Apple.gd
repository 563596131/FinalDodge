extends Area2D

func _on_Apple_area_entered(area): 
	if area is Player:				# if player meet apple
		get_parent().score += 1		# score +1 everytime
		queue_free()					# apple disappear
