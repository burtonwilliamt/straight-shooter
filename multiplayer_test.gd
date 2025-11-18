extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	%PlayerSpawner.spawn_function = _player_spawn_func

func _on_host_pressed():
	peer.create_server(int(%Port.value))
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	%PlayerSpawner.spawn(1)
	%Menu.visible = false

# This gets called by the MultiplayerSpawner on every client to initialize
# the player objects.
# Do not call this function directly. Call the spawn() function instead.
func _player_spawn_func(id: int) -> Node:
	var player = player_scene.instantiate()
	player.name = str(id)
	player.position = %PlayerSpawn.position
	return player

func _add_player(id: int):
	# TODO: Construct any additional spawn data here.
	%PlayerSpawner.spawn(id)


func _on_join_pressed():
	peer.create_client(%IP.text, int(%Port.value))
	multiplayer.multiplayer_peer = peer
	%Menu.visible = false
