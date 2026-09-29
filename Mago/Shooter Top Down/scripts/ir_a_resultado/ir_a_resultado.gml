/// @function    ir_a_resultado(es_victoria)
/// @description Guarda el resultado en global.resultado y navega al room correcto.
///              Victoria → r_victoria  |  Derrota → r_end
/// @param {bool} es_victoria  true = victoria, false = derrota

function ir_a_resultado(es_victoria) {
    if (es_victoria) {
        global.resultado = "victoria";
        room_goto(r_victoria);
    } else {
        global.resultado = "derrota";
        room_goto(r_end);
    }
}
