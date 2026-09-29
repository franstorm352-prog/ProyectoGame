
function c_weapon_blood(pow_level, dir_ataque)
{
    var _shot;

    var _offsetX = lengthdir_x(16, dir_ataque - 90);
    var _offsetY = lengthdir_y(16, dir_ataque - 90);

    switch (pow_level)
    {
        case 1:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_blood);
        break;

        case 2:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_blood);
            _shot.dmg = 15;
        break;

        case 3:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_blood);
            _shot.dmg = 20;
            _shot.lifesteal = 1;
        break;

        default:
            exit;
    }

    _shot.direction = dir_ataque;
    _shot.es_sangre = true; // Identifica este disparo como Sangre (x3 daño en núcleo expuesto)

    canShoot_blood = 0;
    alarm[2]       = reloadSpeed_blood;
}
