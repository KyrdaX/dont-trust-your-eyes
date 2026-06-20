## This is a GDscript Node wich gets automatically added as Autoload while installing the addon.
extends Node
const APP_ID = 1516605421320798389

func _ready() -> void:
	DiscordRPC.app_id = APP_ID
	DiscordRPC.large_image = "cilantro"
	DiscordRPC.large_image_text = "I am playtesting my game, don't spy on me"
	DiscordRPC.details = "Playtesting"
	DiscordRPC.start_timestamp = Time.get_unix_time_from_system()
	
	DiscordRPC.refresh()

func update_rpc(details) -> void:
	DiscordRPC.details = details
	DiscordRPC.refresh()

func _process(_delta) -> void:
	DiscordRPC.run_callbacks()
