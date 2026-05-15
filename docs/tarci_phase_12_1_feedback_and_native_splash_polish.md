# Fase 12.1 — Feedback de éxito y splash nativo

## Objetivo

Reducir ruido en la UX eliminando SnackBars de éxito cuando el resultado ya es evidente, y corregir el recorte del logo en el splash nativo de Android (especialmente Android 12+).

## Política de SnackBars

| Mantener | Eliminar (éxito redundante) |
|----------|----------------------------|
| Errores de acción (`userVisibleErrorMessage`, PDF/email, LinkedIn) | Navegación tras borrar grupo → home |
| Validación (nombre vacío, reglas, mínimos) | Sorteo/equipos/sorteo raffle ejecutado (hero/estado actualizado) |
| `codeCopied` | Rotar código (código visible en UI) |
| Push denegado | Unirse por código (diálogo + `go` al detalle) |
| Avisos de regla de subgrupo antes de guardar | Guardar wishlist (`pop`) |
| `groupActionEmptySubgroup` cuando el subgrupo ya está vacío (validación) | Activar push (tarjeta desaparece con `invalidate`) |
| Debug en home (`kDebugMode` solo) | CRUD subgrupos, reglas, participantes gestionados, renombrar grupo |

**Wizards de creación:** sin snackbar de éxito; navegan al detalle.

**i18n:** las claves ARB de éxito se conservan (pueden reutilizarse en UI); no se hizo limpieza masiva de traducciones.

## Archivos Flutter tocados

| Archivo | Cambio |
|---------|--------|
| `group_detail_screen.dart` | Quitados ~20 SnackBars de éxito en SS |
| `teams_group_detail_screen.dart` | Renombrar equipo, ejecutar, rotar código |
| `raffle_group_detail_screen.dart` | Ejecutar sorteo, rotar código |
| `join_by_code_screen.dart` | Éxito al unirse |
| `wishlist_edit_screen.dart` | Guardado |
| `push_activation_card.dart` | Éxito al activar (mantiene denegado) |

## Splash nativo

**Problema (12.1):** usar `TarciSecret_Vertical_Transparent.png` en `android_12.image` recorta el wordmark por la máscara circular de Android 12+.

**Hotfix 12.1.1:**

| Plataforma | Asset |
|------------|--------|
| Android 12+ (`android_12.image`) | `TarciSecret_Icono_Splash_Android12.png` — isotipo centrado, 1152×1152, contenido ≤640 px |
| Android &lt; 12, iOS (`image` / `image_android` / `image_ios`) | `TarciSecret_Vertical_Transparent.png` |
| Splash Flutter (`splash_screen.dart`) | `BrandAsset.vertical` (marca completa) |

Regenerar asset Android 12+:

```bash
python scripts/make_android12_splash_icon.py
cd src/flutter_app && dart run flutter_native_splash:create
```

## Checklist manual (Stan)

### SnackBars
- [ ] Borrar grupo (SS / Sorteo / Equipos) → vuelve al home sin snackbar
- [ ] Ejecutar sorteo SS / raffle / equipos → hero en “completado”, sin snackbar
- [ ] Rotar código → nuevo código en pantalla, sin snackbar; copiar sigue mostrando “copiado”
- [ ] Unirse por código → diálogo + detalle, sin snackbar
- [ ] Guardar wishlist → vuelve atrás, sin snackbar
- [ ] Activar push OK → tarjeta desaparece; denegado → snackbar de error
- [ ] Error de red/permiso → snackbar de error sigue visible

### Splash
- [ ] Android 12+: logo vertical centrado, sin recorte lateral
- [ ] Android &lt; 12: splash coherente
- [ ] iOS: LaunchScreen con aspect fit, sin deformación

## Commit

```
fix(ux): limpiar feedback de exito y corregir logo del splash nativo
```
