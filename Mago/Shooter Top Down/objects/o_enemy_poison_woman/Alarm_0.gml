if (instance_exists(o_player_mago))
{
    var _dir_ataque = point_direction(x, y, o_player_mago.x, o_player_mago.y);
    var _shot = instance_create_layer(x, y - 8, "Instances", o_shot_enemy_snake);
    _shot.direction = _dir_ataque;
}

// Volver al estado normal
state = "walk";
shoot_timer = shoot_cooldown;
sprite_index = walk_sprite;
