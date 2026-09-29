// Muere si se queda sin HP
if (hp <= 0)
{
    // 15% de soltar un power-up que sube de nivel un arma
    if (irandom(99) < 15 and instance_exists(o_player_mago))
    {
        var _opciones = [];
        
        // Fuego: el jugador siempre lo tiene, chequear solo nivel
        if (o_player_mago.powLevel_fire < 3) array_push(_opciones, 0);
        
        // Otras armas: debe tenerlas y no estar al máximo
        if (o_player_mago.has_rocks && o_player_mago.powLevel_rocks < 3) array_push(_opciones, 1);
        if (o_player_mago.has_blood && o_player_mago.powLevel_blood < 3) array_push(_opciones, 2);
        if (o_player_mago.has_ice   && o_player_mago.powLevel_ice < 3)   array_push(_opciones, 3);
        
        // Si hay alguna opción válida, elegir una al azar
        if (array_length(_opciones) > 0)
        {
            var _idx = irandom(array_length(_opciones) - 1);
            var _drop = _opciones[_idx];
            
            switch (_drop)
            {
                case 0: instance_create_layer(x, y, "Instances", o_pow_fire);  break;
                case 1: instance_create_layer(x, y, "Instances", o_pow_rocks); break;
                case 2: instance_create_layer(x, y, "Instances", o_pow_blood); break;
                case 3: instance_create_layer(x, y, "Instances", o_pow_ice);   break;
            }
        }
    }

    instance_destroy();
    exit;
}

// Ralentizado por hielo
if (slow_timer > 0)
{
	slow_timer--;
	if (slow_timer <= 0) enemy_speed = base_speed;
}

// Stun
if (stun_timer > 0)
{
	stun_timer--;
}
else if (instance_exists(o_player_mago))
{
	// Solo se mueve en estado "walk" (los hijos con otros estados se quedan quietos)
	if (state == "walk")
	{
		dir_to_player = point_direction(x, y, o_player_mago.x, o_player_mago.y);
		x += lengthdir_x(enemy_speed, dir_to_player);
		y += lengthdir_y(enemy_speed, dir_to_player);

		// Animación de ataque (solo cuerpo a cuerpo): cambia de sprite al estar pegado al jugador
		if (ataca_al_tocar)
		{
			if (point_distance(x, y, o_player_mago.x, o_player_mago.y) < 40)
				sprite_index = att_sprite;
			else
				sprite_index = walk_sprite;
		}
	}

	// Voltear hacia el jugador (en cualquier estado)
	if (o_player_mago.x > x)
	{
		if (sprite_mira_derecha) image_xscale = abs(image_xscale);
		else image_xscale = -abs(image_xscale);
	}
	else if (o_player_mago.x < x)
	{
		if (sprite_mira_derecha) image_xscale = -abs(image_xscale);
		else image_xscale = abs(image_xscale);
	}
}
