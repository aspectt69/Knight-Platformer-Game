extends Area2D

# This will export a variable to easily get the node this should affect
# ".." Will refer to its parent
@export var entity_path : NodePath = ".."
@onready var entity = get_node(entity_path)
