// Solo mejora el arma si el jugador ya la tiene desbloqueada
if (other.has_blood and other.powLevel_blood < 3)
{
	other.powLevel_blood += 1;
}
instance_destroy();
