tool

class_name Bush extends Area2D


var BerryScene: PackedScene = preload("res://world/bush/berry/berry.tscn")


signal berry_created(berry)

export(Texture) var bush_texture: Texture

export(float, 1, 1000) var initial_radius := 64.0
export(float, 0.01, 6.28) var angle_draw_factor := 0.2
export var berry_spawn_time := 1.0
export var berry_area_ratio := 0.25

var radius: float setget set_radius, get_radius

var berry_spawn_timer := 0.0


func _ready():
    self.radius = initial_radius


func _physics_process(delta: float):
    if not Engine.editor_hint:
        if not PauseManager.is_paused:
            berry_spawn_timer += delta
            
            if berry_spawn_timer > berry_spawn_time:
                try_spawn_berry()
                
    else:
        self.radius = initial_radius


func set_radius(value: float):
    $CollisionShape2D.scale.x = value
    $CollisionShape2D.scale.y = value
    
    update()
    
    
func get_radius() -> float:
    return $CollisionShape2D.scale.x
    
    
func get_area() -> float:
    return PI * self.radius * self.radius


func grow(area: float):
    var delta_radius = 0.5 * (-self.radius + sqrt(self.radius * self.radius + 4 * area / PI))
    
    self.radius += delta_radius
    update()
    

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
    
    emit_signal("berry_created", berry)
    
    
func _draw():
    var texture_radius = bush_texture.get_size().x / 2.0
    var radial_factor = texture_radius / (4 * PI) # One go around (2*PI radians) maps to R / 2
    var angle := 0.0
    var radius = get_radius()
    
    while angle * radial_factor < self.radius:
        var pos = Math.vector_from_angle(angle) * angle * radial_factor
        draw_set_transform(Vector2.ZERO, angle*radial_factor, Vector2.ONE)
        draw_texture(bush_texture, pos)
        
        angle += Math.PHI * angle_draw_factor
        
        
        
