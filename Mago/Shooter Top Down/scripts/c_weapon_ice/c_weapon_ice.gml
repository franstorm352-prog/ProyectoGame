
function c_weapon_ice(pow_level, dir_ataque)
{
    var _shot;

    var _offsetX = lengthdir_x(16, dir_ataque + 90);
    var _offsetY = lengthdir_y(16, dir_ataque + 90);

    switch (pow_level)
    {
        case 1:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_ice);
        break;

        case 2:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_ice);
            _shot.dmg = 8;
        break;

        case 3:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_ice);
            _shot.dmg = 10;
            _shot.slow_duration = 150;
        break;

        default:
            exit;
    }

    _shot.direction = dir_ataque;
    _shot.es_hielo  = true; // Identifica este disparo como Hielo (interrumpe carga del jefe)

    canShoot_ice = 0;
    alarm[3]     = reloadSpeed_ice;
}
