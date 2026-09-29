// =============================================
// o_cofre  |  Collision con o_player_mago
// =============================================

// Si el cofre ya fue abierto, ignorar la colisión para no abrirlo 2 veces
if (abierto) exit;

// Asegurarnos de que el controlador maestro exista en la partida
if (!instance_exists(o_game_controller)) exit;
var _controlador = o_game_controller;

// Si el jugador ya consiguió las 3 runas, ya no hay más cofres válidos
if (_controlador.cofres_completados) exit;
if (_controlador.cofre_activo_idx >= 3) exit;

// Bloqueo crítico: Si hay una ruleta girando en este momento, no permitir abrir otro cofre.
// Esto evita que se superpongan ruletas y se salten runas.
if (instance_exists(o_ruleta)) exit;

// ─── ABRIR COFRE ─────────────────────────────────────────
// (Cualquier cofre que el jugador toque en el mapa se abrirá)
abierto  = true;
fade_out = true;

// Creamos la interfaz de la Ruleta. Ella elige al azar una runa
// entre las que el jugador todavía no tiene.
instance_create_layer(0, 0, "Instances", o_ruleta);

