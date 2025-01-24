if is_resource {
    repeat wood {
        instance_create_layer(
            x + random_range(-50, 50),
            y + random_range(-50, 50),
            "Instances", oCollectibleWood)
    }
    repeat amber {
        instance_create_layer(
            x + random_range(-50, 50),
            y + random_range(-50, 50),
            "Instances", oCollectibleAmber)
    }
}

if island {
	DetachFromIsland()
}
