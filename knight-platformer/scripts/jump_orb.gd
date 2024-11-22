extends Node2D

func be_bounced_on(bouncer):
	if bouncer.has_method("bounce"):
		print("Hit jump orb")
		bouncer.bounce(-300)
