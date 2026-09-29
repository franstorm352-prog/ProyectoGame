// Solo mejora el arma si el jugador ya la tiene desbloqueada
if (other.has_rocks and other.powLevel_rocks < 3)
{
	other.powLevel_rocks += 1;
}
instance_destroy();
