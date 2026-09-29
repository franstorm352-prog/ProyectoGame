# Mago — Shooter Top Down · Documentación Completa del Proyecto

> **Motor:** GameMaker Studio 2 (GML)
> **Género:** Auto-Shooter Top-Down (estilo Vampire Survivors)
> **Última actualización:** Septiembre 2026

---

## Índice

1. [Resumen del Juego](#1-resumen-del-juego)
2. [Organización del Proyecto (IDE)](#2-organización-del-proyecto-ide)
3. [Estructura de Rooms](#3-estructura-de-rooms)
4. [Jerarquía de Objetos](#4-jerarquía-de-objetos)
5. [Jugador (o_player_mago)](#5-jugador-o_player_mago)
6. [Armas y Niveles](#6-armas-y-niveles)
7. [Enemigos](#7-enemigos)
8. [Sistema de Spawning](#8-sistema-de-spawning)
9. [Sistema de Cofres y Runas](#9-sistema-de-cofres-y-runas)
10. [El Jefe — Mago Supremo Corrupto](#10-el-jefe--mago-supremo-corrupto)
11. [HUD e Interfaz](#11-hud-e-interfaz)
12. [Navegación entre Rooms](#12-navegación-entre-rooms)
13. [Variables de Calibración](#13-variables-de-calibración)
14. [Historial de Cambios](#14-historial-de-cambios)
15. [Cómo descargar y contribuir](#15-cómo-descargar-y-contribuir)

---

## 1. Resumen del Juego

El jugador encarna a un mago que debe **sobrevivir oleadas de enemigos durante 3 minutos**. El disparo es **completamente automático**: el mago apunta y dispara solo al enemigo más cercano. El jugador solo controla el movimiento.

Al cumplirse los 3 minutos, todos los enemigos mueren y aparece el **Mago Supremo Corrupto** (jefe final). Durante esta pelea, el modo de combate cambia radicalmente: los poderes especiales pasan a ser **manuales** (teclas Z, X, C), y el jugador debe usar el poder correcto para contrarrestar cada mecánica del jefe.

---

## 2. Organización del Proyecto (IDE)

El proyecto está organizado en carpetas temáticas dentro del Asset Browser de GameMaker para facilitar su navegación:

- **Enemies:** Todos los enemigos básicos, sus proyectiles, ataques y sprites.
- **Player:** El jugador, sus armas (fuego, hielo, rocas, sangre), power-ups y objetos relacionados.
- **Jefe:** El Mago Supremo Corrupto, sus orbes, proyectiles (básico, medio, triple) y explosiones.
- **Scripts:** Toda la lógica externa y máquinas de estado (ataques del jefe, disparo del jugador).
- **Interfaz:** Menús, HUD, flechas guía, efectos visuales y fondos.
- **System:** Controladores como `o_game_controller` (spawner y gestor de cofres).
- **World:** Cofres, ruletas y elementos del mapa (Rooms).

---

## 3. Estructura de Rooms

```
r_start      → Pantalla de título
r_tutorial   → Controles e instrucciones
r_game       → Juego principal (mapa 4096×4096, viewport 960×540)
r_victoria   → Pantalla de victoria
r_end        → Pantalla de derrota (Game Over)
```

---

## 4. Jerarquía de Objetos

```
o_enemy  (abstracto, sin sprite, sin eventos)
  ├── o_enemy_att              (padre de los proyectiles enemigos)
  │     ├── o_shot_enemy_snake
  │     └── o_shot_lanzero
  └── o_enemy_body             (HP, muerte, hielo, stun, persecución, drop de power-ups)
        ├── o_enemy_basic
        ├── o_enemy_heavy
        ├── o_enemy_chulupi_kamikaze
        ├── o_enemy_poison_woman
        ├── o_enemy_lanzero
        ├── o_enemy_venom
        └── o_jefe             (hereda de o_enemy_body, lógica propia en Step_0)

o_att  (stats base de los proyectiles del jugador: dmg, slow, lifesteal, stun, flags de tipo)
  ├── o_shot_basic_fire
  ├── o_shot_basic_rocks
  ├── o_shot_basic_blood
  └── o_shot_basic_ice

o_shot_jefe_basico  (proyectil base del jefe)
  ├── o_shot_jefe_medio        (mismo disparo, sprite diferente para Fase 2)
  └── o_shot_jefe_triple       (hereda Step y Collision del básico)
```

Cada enemigo hijo llama `event_inherited()` en su `Create_0` y `Step_0` para reusar movimiento, muerte, hielo y stun del padre sin duplicar código.

---

## 5. Jugador (o_player_mago)

### Movimiento
- **Teclas de dirección** (`vk_up`, `vk_down`, `vk_left`, `vk_right`).
- Velocidad fija: `speedMax = 3`.
- La cámara sigue al jugador centrada cada frame.
- **Durante la pelea con el jefe:** cámara fija; el jugador queda confinado al 50% izquierdo de la pantalla.

### Vida y Daño
- `hp = 100`. Si llega a 0 → `ir_a_resultado(false)`.
- `hit_timer` / `iframe_duration = 90` — invulnerabilidad temporal tras daño con parpadeo visual.

### Modo de Combate: Normal vs. Jefe

| Situación | Fuego | Rocas | Sangre | Hielo |
|---|---|---|---|---|
| **Normal** (sin jefe) | Automático | Automático | Automático | Automático |
| **Jefe presente** | Automático | `[Z]` manual | `[X]` manual | `[C]` manual |

### Global Cooldown (durante la pelea del jefe)
Al disparar cualquier poder manual, todos los demás entran en un **cooldown compartido de 1.5 segundos** (90 frames). Esto impide el spam de teclas y obliga a pensar qué poder usar. Se puede mantener la tecla presionada: disparará automáticamente cuando el cooldown termine.

---

## 6. Armas y Niveles

> **Durante la pelea del jefe, los poderes Rocas, Sangre e Hielo se vuelven manuales.**
> Puedes **mantener presionada** la tecla (`[Z]`, `[X]` o `[C]`) y el poder se disparará automáticamente en cuanto el cooldown global termine. No hace falta martillar la tecla.

---

### 🔥 Fuego — Siempre automático (sin tecla)

Disponible desde el inicio. El mago lo dispara solo sin intervención del jugador, tanto en el modo normal como durante el jefe.

| Nivel | Efecto |
|---|---|
| 1 | 1 bola de fuego hacia el enemigo más cercano |
| 2 | 2 bolas en paralelo (mayor cobertura) |
| 3 | 3 bolas en abanico de ±15° (difícil de esquivar) |

- No tiene efecto secundario especial.
- **Contra el jefe:** daña normalmente pero no tiene rol táctico. Es el "relleno" mientras esperas que los otros poderes recarguen.

---

### 🪨 Rocas — Tecla `[Z]` (durante el jefe)

Se desbloquea con el primer cofre. En modo normal dispara automático.

| Nivel | Daño | Extra |
|---|---|---|
| 1 | 30 | — |
| 2 | 45 | — |
| 3 | 60 | 20% de probabilidad de aturdir al enemigo golpeado |

- **El único poder que destruye los Orbes de Escudo del jefe (Fase 2).** Otros proyectiles simplemente rebotan en los orbes sin efecto.
- El aturdimiento del nivel 3 funciona contra enemigos normales, **no contra el jefe** (él es inmune al stun aleatorio).

---

### 🩸 Sangre — Tecla `[X]` (durante el jefe)

Se desbloquea con el segundo cofre. En modo normal dispara automático.

| Nivel | Daño | Extra |
|---|---|---|
| 1 | 10 | Cura 0.5 HP por impacto |
| 2 | 15 | Cura 0.5 HP por impacto |
| 3 | 20 | Cura 1 HP por impacto |

- La curación (**lifesteal**) funciona contra cualquier enemigo, incluyendo el jefe. Cada bala que impacta devuelve vida al jugador, sin pasarse del máximo de 100 HP.
- **Contra el Núcleo Expuesto del jefe (Fase 3) hace ×3 de daño.** Es el poder más importante para terminar la pelea rápido. Con el núcleo activo y nivel 3, cada bala hace 60 de daño y cura 1 HP.

---

### ❄️ Hielo — Tecla `[C]` (durante el jefe)

Se desbloquea con el tercer cofre. En modo normal dispara automático.

| Nivel | Daño | Extra |
|---|---|---|
| 1 | 5 | Ralentiza al enemigo golpeado |
| 2 | 8 | Ralentiza al enemigo golpeado |
| 3 | 10 | Ralentiza con mayor duración |

- El ralentizamiento reduce la velocidad del enemigo a la mitad durante unos segundos. Útil en el modo normal para sobrevivir grupos.
- **Contra el jefe en Fase 3: es el único poder capaz de interrumpir su Carga.** Si disparas Hielo mientras la barra de carga morada está subiendo, el jefe se congela en el sitio durante 3 segundos (aparece la animación de hielo sobre su cabeza) y su Núcleo queda expuesto para que la Sangre haga ×3 de daño.
- Si la carga llega al 100% sin interrumpirse, el jefe lanza un ataque espiral de 36 balas (3 oleadas). **Prioridad máxima: interrumpir siempre la carga.**

---

### Resumen de roles durante el jefe

| Fase del jefe | Qué hacer |
|---|---|
| Fase 1 | Cualquier daño funciona. Usa Fuego (auto) + Rocas para acumular daño rápido. |
| Fase 2 | Destruye los **Orbes con Rocas `[Z]`** primero. Sin eso, eres inmune al resto de daño. |
| Fase 3 | Mantén `[C]` listo para interrumpir la carga. Cuando el núcleo esté expuesto, martilla `[X]` Sangre. |

---

## 7. Enemigos

Todos heredan de `o_enemy_body` (movimiento, muerte, hielo, stun y drop compartidos).

| Enemigo | HP | Velocidad | Comportamiento |
|---|---|---|---|
| `o_enemy_basic` | 30 | 2 | Persigue y daña al tocar |
| `o_enemy_heavy` | 60 | 1 | Persigue y daña al tocar |
| `o_enemy_chulupi_kamikaze` | 15 | 3.5 | Persigue; explota al tocar al jugador (30 dmg) |
| `o_enemy_poison_woman` | 40 | 1.5 | Persigue; dispara veneno a menos de 400 px |
| `o_enemy_lanzero` | 50 | 0.9 | Se detiene a 450 px y dispara 2 flechas |
| `o_enemy_venom` | 45 | 1.2 | Persigue; invoca charcos de veneno (`o_dano_area_venom`) cerca del jugador |

---

## 8. Sistema de Spawning

`o_game_controller` mantiene `spawn_max_enemies = 12` enemigos activos a la vez. Opera con una **Alarm[0]** que corre cada `spawn_interval = 120` frames (2 segundos).

### Zonas del Sistema (relativo al borde de cámara)

```
┌─────────────────────────────────────────┐
│  LÍMITE DE DESTRUCCIÓN (destroy_buffer = 220 px)  │
│   ┌─────────────────────────────────┐   │
│   │  ZONA DE SPAWN                  │   │  spawn_outer = 180 px
│   │   ┌─────────────────────────┐   │   │
│   │   │  gap sin spawn          │   │   │  spawn_inner = 30 px
│   │   │  ┌───────────────────┐  │   │   │
│   │   │  │  CÁMARA [960×540] │  │   │   │
│   │   │  │    [JUGADOR]      │  │   │   │
│   │   │  └───────────────────┘  │   │   │
│   │   └─────────────────────────┘   │   │
│   └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

### Progresión de Dificultad
Cada ciclo sube +1% la probabilidad de un tipo especial (en cascada: heavy → poison → kamikaze → lanzero → venom), hasta un máximo de 16% cada uno. Los enemigos que salen demasiado de la cámara se destruyen automáticamente cada frame en `Step_0`.

### Pausa del Spawner
Cuando el jefe es invocado (`jefe_invocado = true`), el `Alarm[0]` deja de reprogramarse y el spawn de enemigos normales se detiene para siempre en esa partida.

---

## 9. Sistema de Cofres y Runas

### Flujo Completo

1. Al inicio de la partida, `o_game_controller` crea **3 cofres** distribuidos en el mapa (arriba-izquierda, arriba-derecha, abajo-centro).
2. `o_flecha_cofre` dibuja una **flecha amarilla** en el borde de pantalla apuntando al cofre más cercano sin abrir. La flecha desaparece durante la pelea del jefe.
3. Al tocar un cofre, se abre `o_ruleta`: una animación que gira entre las runas disponibles y entrega al azar una que el jugador **no tiene**.
4. La runa se aplica al jugador y el cofre desaparece.
5. Al abrir los 3 cofres, `cofres_completados = true` y la flecha guía se destruye.

### Anti-Race Condition
Si hay una ruleta activa, no se puede abrir otro cofre. Esto evita que dos ruletas se superpongan y se salten runas.

---

## 10. El Jefe — Mago Supremo Corrupto

### Datos Generales
- **HP:** 3000
- **Aparece:** a los 3 minutos exactos (10800 frames a 60 FPS) con cinemática de temblor.
- **Cámara:** se congela. Jefe en el lado derecho; jugador confinado al lado izquierdo.

### Fases

| Fase | HP Restante | Velocidad | Ataque Regular |
|---|---|---|---|
| 1 | 3000 – 2001 | 0.8 | Fan de 3 balas (±15°) |
| 2 | 2000 – 1001 | 1.1 | Fan de 3 balas rápidas (±20°) + **3 Orbes de Escudo** |
| 3 | 1000 – 0 | 1.4 | Fan de 5 balas (±30°) más rápidas + **Ataque de Carga** |

### Mecánicas Especiales

#### Orbes de Escudo (Fase 2)
- El jefe invoca **3 orbes morados** que orbitan a su alrededor.
- Mientras los orbes estén activos, el jefe es **completamente inmune** a cualquier daño.
- Solo **las Rocas (`[Z]`)** destruyen los orbes. El resto de proyectiles rebotan sin efecto.
- Al destruir un orbe, aparece la animación `s_explosion_escudo_jefe`.
- Si se destruyen todos, el jefe es vulnerable. A los 15 segundos, regenera **2 nuevos orbes**.

#### Ataque de Carga / Núcleo Expuesto (Fase 3)
- Cada 10 segundos, el jefe **carga un ataque definitivo** durante 3 segundos (180 frames).
  - Una barra de progreso morada muestra el avance de la carga.
  - El jefe se tiñe de morado progresivamente.
- Si el jugador le dispara **Hielo (`[C]`)** durante la carga → la carga se **interrumpe**, el jefe queda **aturdido** durante 3 segundos (aparece animación `s_aturdido_congelacion` encima) y su **Núcleo queda expuesto**.
- Si **no se interrumpe** → el jefe lanza un **ataque espiral de 3 oleadas** rotativas (12 balas por oleada, rotadas 15° entre sí), que cubren los huecos de la oleada anterior. Durante las ráfagas espirales, el ataque regular se pausa.

#### Núcleo Expuesto
- Dura **3 segundos**. Un círculo rojo pulsante aparece sobre el jefe.
- **Sangre (`[X]`) hace x3 de daño**. El resto hace x2.
- El jefe es **completamente inmune al aturdimiento aleatorio** de los disparos normales; solo se aturde al interrumpir la carga.

### Cinemática de Muerte
Al llegar a 0 HP, los proyectiles y orbes se destruyen, una explosión aparece, el jefe se desvanece durante 6 segundos y llama `ir_a_resultado(true)`.

---

## 11. HUD e Interfaz

### HUD del Jugador (esquina superior izquierda)
- 4 slots de runas con el sprite de cada una.
- Etiqueta `Nv X/3` debajo de cada slot.
- **Durante la pelea del jefe:** cada slot muestra la tecla correspondiente (`[Z]`, `[X]`, `[C]`) y una barra de cooldown:
  - **Morado lleno** = listo para disparar.
  - **Rojo** = en Global Cooldown (esperando 1.5s tras el último disparo).
  - **Morado oscuro** = recargando el propio enfriamiento del arma.

### HUD del Jugador (esquina inferior izquierda)
- Barra de vida HP que va de verde (lleno) a rojo (bajo).

### HUD del Jefe (parte inferior derecha)
- Barra de vida roja (Fase 1), naranja (Fase 2) o morada (Fase 3).
- Nombre "MAGO SUPREMO CORRUPTO — FASE X".
- Barra de carga morada (Fase 3, cuando está cargando).
- Indicador rojo pulsante + texto "NUCLEO EXPUESTO [X] SANGRE x3".

### Timer (esquina superior derecha)
- Cuenta el tiempo de partida en formato `MM:SS`.

---

## 12. Navegación entre Rooms

- `o_menu` gestiona los cambios de room: cualquier tecla avanza desde `r_start`/`r_tutorial`; en `r_end`/`r_victoria`, `[R]` reinicia y `[ESC]` sale.
- `ir_a_resultado(es_victoria)` es la única forma de terminar una partida: fija `global.resultado` y cambia de room.
- `o_game_controller` no es persistente → cada partida nueva arranca limpia (cofres, cronómetro y oleadas reiniciados).

---

## 13. Variables de Calibración

| Archivo | Variable | Valor | Qué cambia |
|---|---|---|---|
| `o_game_controller` | `spawn_max_enemies` | `12` | Enemigos simultáneos objetivo |
| `o_game_controller` | `spawn_interval` | `120` | Frecuencia de revisión de spawn (frames) |
| `o_game_controller` | `destroy_buffer` | `220` | Margen fuera de cámara para destruir enemigo |
| `o_game_controller` | `timer_frames >= 10800` | `10800` | Frames para que aparezca el jefe (3 min) |
| `o_player_mago` | `hp` | `100` | Vida del jugador |
| `o_player_mago` | `iframe_duration` | `90` | Duración de invulnerabilidad (frames) |
| `o_player_mago` | `global_cd_max` | `90` | Global Cooldown en pelea del jefe (frames) |
| `o_jefe` | `max_hp` | `3000` | Vida del jefe |
| `o_jefe` | `dash_interval` | `480` | Frames entre dashes (Fase 1) |
| `o_jefe` | `carga_cooldown >= 600` | `600` | Frames entre cargas (Fase 3) |
| `o_enemy_body` | drop power-up | `15%` | Probabilidad de drop al morir |

---

## 14. Historial de Cambios

Esta sección detalla todo lo que fue implementado y corregido a lo largo del desarrollo, en orden cronológico.

### Fundamentos del Juego (Primera Fase)

- **Sistema de movimiento:** Teclas de dirección (`vk_up/down/left/right`). La cámara sigue al jugador con clampeo a los bordes del mapa.
- **Auto-disparo:** El jugador dispara automáticamente al `instance_nearest(x, y, o_enemy_body)`. No se requiere input del jugador para atacar en el modo normal.
- **Sistema de iframes:** Al recibir daño, el jugador parpadea y es invulnerable por `iframe_duration = 90` frames.
- **Jerarquía de enemigos:** Todos los enemigos heredan de `o_enemy_body` (HP, muerte, hielo, stun, drop, movimiento) usando `event_inherited()`.
- **Spawner dinámico:** `o_game_controller` mantiene `spawn_max_enemies` enemigos activos, spawnean fuera de la cámara y se destruyen si se alejan demasiado.
- **Progresión de dificultad:** El spawner sube progresivamente la probabilidad de tipos especiales (heavy → poison → kamikaze → lanzero → venom).

### Sistema de Runas y Cofres

- **3 cofres** distribuidos en zonas del mapa al inicio de cada partida.
- **Ruleta (`o_ruleta`):** Animación que al abrirse entrega una runa que el jugador no tiene.
- **Anti-race condition:** Si hay una ruleta activa, no se puede abrir otro cofre.
- **Flecha guía (`o_flecha_cofre`):** Apunta siempre al cofre más cercano sin abrir, con distancia en px.
- **Drops de power-ups:** Los enemigos sueltan orbes de nivel con 15% de probabilidad. Solo dropean runas desbloqueadas y que no estén al nivel máximo.
- **Runas al nivel 3:** Si una runa llega a nivel 3, los drops de ese tipo en el suelo desaparecen automáticamente.

### El Jefe — Rediseño Completo (3 Fases)

- **Fase 1 (Dash):** El jefe se desplaza verticalmente y hace dashes hacia el jugador cada 8 segundos. Telegrafía el dash con parpadeo rojo.
- **Fase 2 (Orbes de Escudo):** Al llegar a 2000 HP, invoca 3 orbes que orbitan a su alrededor. El jefe es inmune mientras estén activos. Solo las Rocas (`[Z]`) los destruyen. Cada orbe destruido genera animación `s_explosion_escudo_jefe`. Si se destruyen todos, regenera 2 nuevos en 15 segundos.
- **Fase 3 (Carga y Núcleo):** Al llegar a 1000 HP. Cada 10 segundos carga un ataque definitivo durante 3 segundos. Si el Hielo (`[C]`) lo interrumpe, el jefe queda aturdido y el núcleo se expone (la Sangre hace x3 de daño). Si no se interrumpe, dispara 3 oleadas de 12 balas en espiral, rotadas 15° entre sí.

### Mecánicas de Combate Manual (Pelea del Jefe)

- **Cambio de modo:** Al detectar la presencia de `o_jefe`, los poderes Rocas/Sangre/Hielo se vuelven manuales (teclas `[Z]`, `[X]`, `[C]`). El fuego sigue siendo automático.
- **Global Cooldown (1.5 segundos):** Al usar cualquier poder manual, todos los demás entran en cooldown compartido. Esto penaliza el spam y premia la precisión.
- **Hold de tecla:** Se puede mantener presionada la tecla y el poder se disparará automáticamente cuando el cooldown termine.
- **Garantía de runas:** Si el jugador llega al jefe sin alguna runa, se la otorga automáticamente al nivel 1 antes de que aparezca.

### HUD y Feedback Visual

- **Barras de cooldown con GCD:** Las barras de cooldown en el HUD cambian a rojo durante el Global Cooldown para que el jugador sepa que está en penalización.
- **Barra de carga del jefe:** Reemplazó el texto parpadeante por una barra de progreso morada visible que se llena durante los 3 segundos de carga.
- **Animación de aturdimiento:** Al interrumpir la carga, aparece `s_aturdido_congelacion` encima del jefe (escalado x4), sincronizado exactamente con el estado de aturdimiento.
- **Indicador de núcleo expuesto:** Círculo rojo pulsante sobre el jefe con texto "NUCLEO EXPUESTO [X] SANGRE x3". Desaparece al morir el jefe.
- **Timer MM:SS** en esquina superior derecha.

### Bugs Corregidos

| Bug | Causa | Corrección |
|---|---|---|
| Jefe aparecía al minuto, no a los 3 minutos | `timer_frames >= 3600` en vez de `10800` | Corregido a `10800` |
| Cámara se teletransportaba al inicio de la cinemática | El código calculaba posición sin clampear al mapa | Añadido `clamp()` en `o_cinematica_jefe` (Step y Alarm) |
| Flecha de cofre aparecía durante la pelea del jefe | Sin verificación de `instance_exists(o_jefe)` | Añadido `if (instance_exists(o_jefe)) exit;` al inicio |
| El jefe miraba hacia el lado incorrecto al aturdirse | `exit;` en el bloque de stun cancelaba el código de escala | Reemplazado `exit` por bloque `if/else` estructurado |
| Animación de congelación aparecía en Fase 2 | El hielo tenía `stun_chance` genérico heredado de enemigos normales | Eliminado el stun aleatorio para el jefe; solo se aturde al interrumpir la carga |
| Núcleo expuesto seguía mostrándose después de matar al jefe | La variable `nucleo_expuesto` no se limpiaba en la secuencia de muerte | Añadido `nucleo_expuesto = false` en el bloque de muerte |
| Transiciones de fase no ocurrían | Los bloques `if (hp <= 2000...)` quedaron dentro del bloque de stun por error de refactor | Movidos fuera del bloque de stun, ejecutan siempre |
| El jefe cruzaba al lado del jugador | El bloque de confinamiento fue eliminado accidentalmente en un refactor | Restaurado el `clamp()` de posición X/Y del jefe |
| Proyectiles del jefe se veían de lado | `image_angle = direction` sin compensar el sprite dibujado hacia arriba | Cambiado a `image_angle = direction - 90` |
| Spawn de enemigos seguía activo durante la pelea del jefe | El `Alarm[0]` no verificaba `jefe_invocado` | Añadido `if (jefe_invocado) exit;` al inicio del Alarm |
| Ruleta con doble decremento de `stop_timer` | El `else` del bloque de destrucción se ejecutaba el mismo frame que `reward_applied` | Corregida la lógica del bloque `else` |

### Limpieza y Optimización

- **Código muerto eliminado:** Variables duplicadas en `o_jefe/Create_0.gml`, comentarios con codificación rota.
- **Objetos huérfanos auditados:** Todos los objetos del proyecto tienen referencias activas; no hay código huérfano.
- **Proyectiles auto-destruibles:** Todos los proyectiles (del jefe y del jugador) verifican cada frame si salieron del mapa y se destruyen, previniendo pérdidas de memoria.
- **Inmunidad correcta por herencia:** `o_shot_jefe_triple` hereda de `o_shot_jefe_basico`, compartiendo automáticamente la lógica de colisión con el jugador.

---

## 15. Cómo descargar y contribuir

### Clonar el proyecto
1. Copia la URL del repositorio: `https://github.com/franstorm352-prog/ProyectoGame.git`
2. En tu terminal o consola Git, ejecuta:
   ```bash
   git clone https://github.com/franstorm352-prog/ProyectoGame.git
   ```
3. Abre GameMaker Studio 2 y carga el archivo **Shooter Top Down.yyp** desde la carpeta clonada.

### Subir aportes (si eres colaborador)
1. Crea una rama para tu nueva función o corrección:
   ```bash
   git checkout -b nombre-de-tu-rama
   ```
2. Haz tus cambios en el IDE de GameMaker y guárdalos.
3. Añade los cambios y haz un commit explicando qué hiciste:
   ```bash
   git add .
   git commit -m "Descripción corta de tus cambios"
   ```
4. Sube tu rama al repositorio remoto:
   ```bash
   git push origin nombre-de-tu-rama
   ```
5. Crea un **Pull Request** en GitHub para que tus cambios sean revisados e integrados a la rama principal.
