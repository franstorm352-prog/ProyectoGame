// =============================================
// o_cofre  |  Step Event
// Fade out una vez abierto
// =============================================
if (fade_out)
{
    fade_alpha -= 0.015;
    image_alpha = fade_alpha;
    if (fade_alpha <= 0)
    {
        instance_destroy();
        exit;
    }
}
