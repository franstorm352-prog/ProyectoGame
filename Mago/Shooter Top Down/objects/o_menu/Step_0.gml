// o_menu — Controlador de navegacion entre rooms
// En r_victoria y r_end: muestra el resultado y vuelve a r_start.
// En otros rooms: avanza al siguiente room con cualquier tecla.

if (room == r_game) exit; // nunca navegar desde el juego

// Inicializar global si no existe (precaución)
if (!variable_global_exists("resultado")) global.resultado = "derrota";

// Detectar si estamos en una pantalla final (victoria o derrota)
var _en_pantalla_final = (room == r_end || room == r_victoria);

if (_en_pantalla_final)
{
    // Victoria: cualquier tecla cierra el juego
    if (room == r_victoria)
    {
        if (keyboard_check_pressed(vk_anykey)) game_end();
        exit;
    }
    
    // Derrota: R para reintentar, ESC para salir
    if (keyboard_check_pressed(ord("R")))
    {
        room_goto(r_start);
        exit;
    }
    
    if (keyboard_check_pressed(vk_escape))
    {
        game_end();
        exit;
    }
}
else
{
    // En r_start o r_tutorial, avanzar con cualquier tecla
    if (keyboard_check_pressed(vk_anykey))
    {
        room_goto_next();
    }
}
