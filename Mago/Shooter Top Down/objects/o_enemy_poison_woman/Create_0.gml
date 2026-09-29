hp = 40;
enemy_speed = 1.5;
image_xscale = 2;
image_yscale = 2;

// Disparo de veneno
shoot_cooldown = 120;
shoot_timer = shoot_cooldown;

// Sprites de caminar / apuntar
walk_sprite = sprite_index;
att_sprite = s_enemy_poison_woman_att;

event_inherited();

ataca_al_tocar = false;       // ataca a distancia
