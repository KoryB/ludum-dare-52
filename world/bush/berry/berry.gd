class_name Berry extends Area2D


signal eaten(berry, bug)
signal harvested(berry)


export var ripen_time := 5.0
export var max_health := 10.0

const MaxArea := PI * 16.0 * 16.0

var health := 0.01

var is_dead := false
var is_harvested := false
    
    
func _ready():
    scale = Vector2.ZERO
    rotation = rand_range(0, 2*PI)
    

func _physics_process(delta: float):
    if not PauseManager.is_paused:
        health += (max_health / ripen_time) * delta
        health = min(max_health, health)
        
        scale = Math.Vector2f(health / max_health)

        if is_dead:
            on_die()
            
        if is_harvested:
            on_harvested()


# Returns if the berry is dead after the damage
func damage(from, amount: float) -> bool:
    health -= amount
    if health < 0:
        is_dead = true
        
        emit_signal("eaten", self, from)
        
    return is_dead
    

func on_die():
    queue_free()
    

func on_harvested():
    queue_free()


func is_ripe() -> bool:
    return health >= max_health
    

func harvest():
    if is_ripe() and not is_harvested and not is_dead:
        emit_signal("harvested", self)
        is_harvested = true
        
    return is_harvested
