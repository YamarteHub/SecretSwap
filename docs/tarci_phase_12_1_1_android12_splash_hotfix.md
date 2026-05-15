# Fase 12.1.1 — Hotfix splash Android 12+

## Diagnóstico confirmado

- `android_12.image` usaba `TarciSecret_Vertical_Transparent.png` (logo + wordmark apilados).
- Android 12+ aplica `windowSplashScreenAnimatedIcon` con **máscara circular** (~768 px de diámetro útil en lienzo 1152×1152).
- Resultado: rostro/torso visibles, wordmark partido, composición inaceptable.

## Decisión de producto

| Capa | Contenido |
|------|-----------|
| Native splash Android 12+ | Solo isotipo Tarci + regalo, sin texto |
| Native splash Android &lt; 12 / iOS | Wordmark vertical transparente |
| Splash Flutter | `BrandAsset.vertical` + tagline + loading (sin cambios) |

## Implementación

1. Script `scripts/make_android12_splash_icon.py` genera `TarciSecret_Icono_Splash_Android12.png` (1152×1152, isotipo ≤640 px centrado).
2. `pubspec.yaml`:
   - `image` / `image_android` / `image_ios` → vertical
   - `android_12.image` → isotipo splash-safe
3. `dart run flutter_native_splash:create`

## Checklist manual

- [ ] Android 12+ (emulador o dispositivo): isotipo completo, sin recorte del wordmark
- [ ] Android &lt; 12: marca vertical legible
- [ ] iOS: LaunchScreen coherente
- [ ] Tras native splash → splash Flutter con logo vertical y autoría

## Commit

```
fix(splash): isotipo con zona segura para Android 12+ nativo
```
