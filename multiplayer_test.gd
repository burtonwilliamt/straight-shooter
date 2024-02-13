extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	peer.create_server(int($Port.text))
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player(1)

func _add_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)


func _on_join_pressed():
	peer.create_client($IP.text, int($Port.text))
	multiplayer.multiplayer_peer = peer
