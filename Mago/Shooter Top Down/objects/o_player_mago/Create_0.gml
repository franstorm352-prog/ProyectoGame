// Stats del jugador
hSpeed = 0;
vSpeed = 0;

speedMax = 3;
estado = "Up";

// Armas
has_fire  = true;   
has_rocks = false;  
has_blood = false;  
has_ice   = false;  
// Disparo — fuego
canShoot_fire     = 1;
reloadSpeed_fire  = 60;
powLevel_fire     = 1;

// Disparo — rocas
canShoot_rocks    = 1;
reloadSpeed_rocks = 90;
powLevel_rocks    = 1;

// Disparo — sangre
canShoot_blood    = 1;
reloadSpeed_blood = 75;
powLevel_blood    = 1;

// Disparo — hielo
canShoot_ice      = 1;
reloadSpeed_ice   = 70;
powLevel_ice      = 1;

// Global Cooldown (para modo manual del jefe)
global_cd = 0;
global_cd_max = 90; // 1.5 segundos a 60fps

hp = 100;

// Inventario de runas en pantalla (posición de los slots)
inv_x     = 20;   // esquina superior izquierda
inv_y     = 20;
slot_size = 44;   // tamaño de cada slot
slot_pad  = 8;    // separación entre slots

// Invulnerabilidad tras recibir daño
hit_timer      = 0;  
iframe_duration = 90; 
