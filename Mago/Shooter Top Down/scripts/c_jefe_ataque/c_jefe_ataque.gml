
function c_jefe_ataque(fase, dir_ataque)
{
    var _shot;

    switch (fase)
    {
        case 1:
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_basico);
            _shot.direction = dir_ataque;
        break;

        case 2:
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction    = dir_ataque - 20;
            _shot.sprite_index = o_shot_jefe_medio;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction    = dir_ataque;
            _shot.sprite_index = o_shot_jefe_medio;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction    = dir_ataque + 20;
            _shot.sprite_index = o_shot_jefe_medio;
        break;

        case 3:
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction = dir_ataque - 30;
            _shot.speed = 5;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction = dir_ataque - 15;
            _shot.speed = 5;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction = dir_ataque;
            _shot.speed = 5;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction = dir_ataque + 15;
            _shot.speed = 5;
            _shot = instance_create_layer(x, y, "Instances", o_shot_jefe_triple);
            _shot.direction = dir_ataque + 30;
            _shot.speed = 5;
        break;
    }
}
