// Solo mejora el arma si el jugador ya la tiene desbloqueada
if (other.has_fire and other.powLevel_fire < 3)
{
	other.powLevel_fire += 1;
}
instance_destroy();
