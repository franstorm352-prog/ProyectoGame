// =============================================
// o_ruleta  |  Create Event
// =============================================

// --- Runas disponibles (las que aún no tiene el jugador) ---
// runas_slot guarda en qué slot del inventario está cada una (0=fire, 1=rocks, 2=blood, 3=ice)
var _ctrl = o_game_controller;
runas_spr  = [];
runas_tipo = [];
runas_slot = [];

var _tipos = ["rocks", "blood", "ice"];
var _sprs  = [s_pow_rocks, s_pow_blood, s_pow_ice];

for (var _i = 0; _i < 3; _i++) {
    if (!_ctrl.runas_dadas[_i]) {
        array_push(runas_spr,  _sprs[_i]);
        array_push(runas_tipo, _tipos[_i]);
        array_push(runas_slot, _i + 1);
    }
}
n_runas = array_length(runas_spr);

// --- Qué runa gana: una al azar entre las que todavía no tiene el jugador ---
runa_ganador_idx = irandom(n_runas - 1);

// --- Giro: una sola runa en el centro que va cambiando cada vez más lento ---
indice       = 0;   // runa que se ve ahora
cambio_t     = 3;   // frames entre un cambio y el siguiente (empieza rápido)
cambio_max   = 20;  // cuando el tiempo entre cambios llega a esto, empieza a frenar
cambio_timer = cambio_t;

// --- Estados ---
estado         = "girando";  // -> "parado"
stop_timer     = 75;         // frames de espera al detenerse
reward_applied = false;
runa_nombre_ganada = "";

// Se dibuja por encima del inventario
depth = -9990;
