class_name Berry extends Area2D


signal eaten(berry, bug)
signal harvested(berry)


export var ripen_time := 5.0
export var max_health := 10.0

const MaxArea := PI * 16.0 * 16.0

onready var health := max_health

var ripen_timer = 0.0

var is_dead := false
var is_harvested := false
    
    
func _ready():
    scale = Vector2.ZERO
    

func _physics_process(delta: float):
    ripen_timer += delta
    scale = Math.Vector2f(min(1.0, ripen_timer / ripen_time))

    if is_dead:
        on_die()
        
    if is_harvested:
        on_harvested()


# Returns if the berry is dead after the damage
func damage(from, amount: float) -> bool:
    max_health -= amount
    if max_health < 0:
        is_dead = true
        
        emit_signal("eaten", self, from)
        
    return is_dead
    

func on_die():
    queue_free()
    

func on_harvested():
    queue_free()


func is_ripe() -> bool:
    return ripen_timer >= ripen_time
    

func harvest():
    if is_ripe():
        emit_signal("harvested", self)
        is_harvested = true
        
    return is_harvested
