extends KinematicBody2D

const SlimeDeathEffect = preload("res://Nodes/SlimeDeathEffect/SlimeDeathEffect.tscn")

var player = null
var move = Vector2.ZERO
var speed = 0.5
var vida = 5
var vivo = true

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	move = Vector2.ZERO
	
	if player != null:
		move = position.direction_to(player.position) * speed
		
	else:
		move = Vector2.ZERO
		animationPlayer.play("idle")
		
		
	move = move.normalized()
	move = move_and_collide(move)





func verificaVivo():
	if vida >= 1:
		vivo = true
	else:
		vivo = false
		animationPlayer.stop()
		

func _on_Area2D_body_entered(body):
	if (body.is_in_group("Player")):
		if body != self:
			player = body
			animationPlayer.play("jumping")
		else:
			move = Vector2.ZERO
			animationPlayer.play("idle")


func _on_Area2D_body_exited(body):
	if (body.is_in_group("Player")):
		player = null


func _on_Attack_Animation_body_entered(body):
	if (body.is_in_group("Player")):
		if body != self:
			animationPlayer.play("attacking")
	else:
		move = Vector2.ZERO
		animationPlayer.play("jumping")


func _on_Attack_Animation_body_exited(body):
	animationPlayer.play("jumping")


func _on_Dar_Dano_body_entered(body):
	if (body.is_in_group("Player")):
		animationPlayer.play("hit")
		vida -= 1
		$Slime_Sound.play()
		print("Slime: ", vida)
		if (vida == 0):
			var slimeDeathEffect = SlimeDeathEffect.instance()
			get_parent().add_child(slimeDeathEffect)
			slimeDeathEffect.global_position = global_position
			queue_free()
