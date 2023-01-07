class_name Bush extends Area2D


var BerryScene: PackedScene = preload("res://world/bush/berry/berry.tscn")


export var initial_radius := 64.0
export var berry_spawn_time := 1.0
export var berry_area_ratio := 0.25

var radius: float setget set_radius, get_radius

var berry_spawn_timer := 0.0


func _ready():
    self.radius = initial_radius


func _physics_process(delta: float):
    berry_spawn_timer += delta
    
    if berry_spawn_timer > berry_spawn_time:
        try_spawn_berry()


func set_radius(value: float):
    $CollisionShape2D.scale.x = value
    $CollisionShape2D.scale.y = value
    
    
func get_radius() -> float:
    return $CollisionShape2D.scale.x
    
    
func get_area() -> float:
    return PI * self.radius * self.radius


func grow(area: float):
    var delta_radius = 0.5 * (-self.radius + sqrt(self.radius * self.radius + 4 * area / PI))
    
    self.radius += delta_radius
    

func try_spawn_berry():
    berry_spawn_timer = 0.0
    
    if calculate_berry_area_ratio() < berry_area_ratio:
        spawn_berry()
        
        
func calculate_berry_area_ratio():
    return get_tree().get_nodes_in_group("Berry").size() * Berry.MaxArea / get_area()
    

func spawn_berry():
    var berry = BerryScene.instance()
    berry.position = Math.random_vector_polar(0, self.radius)
    
    add_child(berry)
