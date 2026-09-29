
function c_weapon_standard(pow_level, dir_ataque)
{
    var _shot;

    var _offsetX = lengthdir_x(8, dir_ataque - 90);
    var _offsetY = lengthdir_y(8, dir_ataque - 90);

    switch (pow_level)
    {
        case 1:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque;
        break;

        case 2:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque;
            _shot = instance_create_layer(x - _offsetX, y - 8 - _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque;
        break;

        case 3:
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque - 15;
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque;
            _shot = instance_create_layer(x + _offsetX, y - 8 + _offsetY, "att", o_shot_basic_fire);
            _shot.direction = dir_ataque + 15;
        break;

        default:
            exit;
    }

    canShoot_fire = 0;
    alarm[0]      = reloadSpeed_fire;
}
