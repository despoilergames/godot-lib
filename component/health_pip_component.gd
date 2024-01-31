class_name HealthPipComponent extends PipComponent

@export var health_component: HealthPipComponent


func remove(amount: int) -> int:
	amount = super(amount)
	if value <= 0 and health_component:
		health_component.remove(amount)
		return 0
	return amount
