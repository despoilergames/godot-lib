class_name HealthPoolComponent extends PoolComponent

@export var health_component: HealthPoolComponent


func remove(amount: float) -> float:
	amount = super(amount)
	if value <= 0 and health_component:
		health_component.remove(amount)
		return 0
	return amount
