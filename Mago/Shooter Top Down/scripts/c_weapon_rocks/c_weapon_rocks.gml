
function c_weapon_rocks(pow_level, dir_ataque)
{
    var _shot;

    var _offsetX = lengthdir_x(8, dir_ataque + 90);
    var _offsetY = lengthdir_y(8, dir_ataque + 90);

    switch (pow_level)
    {
        case 1:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_rocks);
        break;

        case 2:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_rocks);
            _shot.dmg = 45;
        break;

        case 3:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_rocks);
            _shot.dmg = 60;
            _shot.stun_chance = 20;
        break;

        default:
            exit;
    }

    _shot.direction = dir_ataque;
    _shot.es_roca   = true; // Identifica este disparo como Rocas (rompe orbes del jefe)

    canShoot_rocks = 0;
    alarm[1]       = reloadSpeed_rocks;
}
