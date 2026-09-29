// =============================================
// o_game_controller  |  Create Event
// Gestor central: Límite exterior dinámico + Spawning en franja de cámara
// =============================================

randomize(); // Asegurar que el RNG sea diferente en cada ejecución

// Resultado de partida (se sobreescribe al ganar o perder)
global.resultado = "derrota";

// --- LÍMITE EXTERIOR DE DESTRUCCIÓN ---
// Píxeles más allá del borde de la cámara donde el enemigo se destruye.
// Estimado desde imagen: rectángulo rojo ≈ 220 px por lado del viewport.
// Aumentar si los enemigos se destruyen demasiado rápido al alejarse.
destroy_buffer = 220;

// --- FRANJA DE SPAWN ---
// Los spawners se definen RELATIVOS al borde de la cámara (no al mapa).
// Un enemigo aparece en la franja [spawn_inner, spawn_outer] px
// fuera del borde de la cámara, en cualquiera de los 4 lados.

// Mínimo px fuera del borde de cámara (evita spawn visible dentro de cámara).
// Relativo al viewport: 30 px más allá del borde azul de la imagen.
spawn_inner = 30;

// Máximo px fuera del borde de cámara (debe ser < destroy_buffer).
// Relativo al viewport: 180 px fuera del borde azul = dentro de la zona verde.
spawn_outer = 180;

// --- TEMPORIZACIÓN ---
// Frames entre cada ciclo de revisión y reposición de enemigos (60 fps = 1 s).
spawn_interval = 120; // 2 segundos

// --- CANTIDAD OBJETIVO ---
// Número de enemigos que el sistema intentará mantener en escena a la vez.
// Al morir o ser destruidos, el Alarm[0] repone los faltantes.
spawn_max_enemies = 12;

// --- DIFICULTAD PROGRESIVA: probabilidad de o_enemy_heavy ---
heavy_chance      = 0;   // % actual de que un spawn sea heavy
heavy_chance_max  = 16;  // tope máximo de probabilidad
heavy_chance_step = 1;   // cuánto sube heavy_chance por cada ciclo de spawn

// --- DIFICULTAD PROGRESIVA: probabilidad de o_enemy_poison_woman ---
poison_chance      = 0;
poison_chance_max  = 16;
poison_chance_step = 1;

// --- DIFICULTAD PROGRESIVA: probabilidad de o_enemy_chulupi_kamikaze ---
kamikaze_chance      = 0;
kamikaze_chance_max  = 16;
kamikaze_chance_step = 1;

// --- DIFICULTAD PROGRESIVA: probabilidad de o_enemy_lanzero ---
lanzero_chance      = 0;
lanzero_chance_max  = 16;
lanzero_chance_step = 1;

// --- DIFICULTAD PROGRESIVA: probabilidad de o_enemy_venom ---
venom_chance      = 0;
venom_chance_max  = 16;
venom_chance_step = 1;

// Arrancar el primer ciclo de spawning
alarm[0] = spawn_interval;

// Dibujar el overlay por encima de todos los objetos del room
depth = -9999;

// =============================================
// --- SISTEMA DE COFRES Y RUNAS ---
// =============================================

// Registro de qué runas ya se entregaron (0=rocks, 1=blood, 2=ice)
runas_dadas[0] = false;
runas_dadas[1] = false;
runas_dadas[2] = false;

// Índice del cofre que el jugador debe abrir ahora
cofre_activo_idx   = 0;
cofres_completados = false;

// Generar 3 cofres: uno al azar en cada zona del mapa
// (las zonas están lejos entre sí y lejos del jugador, que empieza en el centro)
cofre_ids[0] = instance_create_layer(300  + irandom(1200), 300 + irandom(1200), "Instances", o_cofre);  // arriba a la izquierda
cofre_ids[1] = instance_create_layer(2600 + irandom(1200), 300 + irandom(1200), "Instances", o_cofre);  // arriba a la derecha
cofre_ids[2] = instance_create_layer(1000 + irandom(2000), 2700 + irandom(1000), "Instances", o_cofre); // abajo, en el medio

// Crear flecha guía que apunta al cofre activo
flecha_inst = instance_create_layer(0, 0, "Instances", o_flecha_cofre);


// Timer de partida
timer_frames = 0;
jefe_invocado = false;

