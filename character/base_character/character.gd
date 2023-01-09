class_name Character extends KinematicBody2D

export var inv_mass := 0.1
export var linear_dampening := 0.85
export var acceleration_factor := 0.7

var is_dead = false

var forces := Vector2(0, 0)
var base_velocity := Vector2(0, 0)
var force_velocity := Vector2(0, 0)

var target_velocity := Vector2(0, 0)
var facing_direction := Vector2.UP

var life := 0.0

var state_machine := StateMachine.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
    if not PauseManager.is_paused:
        do_physics_process(delta)
        if is_dead:
            on_die()
    

func do_physics_process(delta: float):
    state_machine.pre_update(self, delta)
    state_machine.update(self, delta)
    update_physics(delta)
    state_machine.post_update(self, delta)
    
    life += delta
    
    do_other_process(delta)
    

func do_other_process(delta: float):
    pass
    
    
func update_physics(delta: float):
    var accel := forces * inv_mass
    force_velocity += accel * delta
    
    base_velocity = base_velocity.linear_interpolate(target_velocity, acceleration_factor)
    
    var _a = move_and_slide(force_velocity + base_velocity)
    
    force_velocity *= linear_dampening
    base_velocity *= linear_dampening
    
    clear_forces()
    
    
func clear_forces():
    forces = Vector2(0, 0)
    

func get_velocity():
    return force_velocity + base_velocity
    

func apply_force(force: Vector2):
    forces += force 
    

func apply_impulse(impulse: Vector2):
    force_velocity += impulse * inv_mass
    

func kill():
    is_dead = true
    

func on_die():
    pass
