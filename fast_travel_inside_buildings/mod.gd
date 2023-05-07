extends ContentInfo

const RESOURCES = {
	"res://menus/map_pause/InteractiveMap.gd": preload("files/interactivemap.gd"),
}

func _init() -> void:

	for k in RESOURCES:
		RESOURCES[k].take_over_path(k)
