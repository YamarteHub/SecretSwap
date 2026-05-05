# Configuracion local de entornos

TarciSwap soporta dos modos en desarrollo:

- emuladores locales (rapido y tecnico);
- Firebase real `tarciswap-dev` (mas cercano a produccion).

## Emuladores locales (persistente)

Desde la raiz del repositorio:

```powershell
firebase emulators:start --only auth,firestore,functions --project tarciswap-dev --import=./emulator-data --export-on-exit=./emulator-data
```

Opcionalmente, desde `src/firebase_functions` puedes usar:

```powershell
npm run emulators:persistent
```

Luego arranca Flutter usando emuladores:

```powershell
flutter run -d emulator-5554 --dart-define=USE_FIREBASE_EMULATORS=true --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2
```

## Firebase real de desarrollo (`tarciswap-dev`)

Para usar Auth/Firestore/Functions reales (sin emuladores):

```powershell
flutter run -d emulator-5554 --dart-define=USE_FIREBASE_EMULATORS=false
```

Notas:

- Si `USE_FIREBASE_EMULATORS=false` o no se define, la app usa Firebase real.
- En release, la app nunca conecta a emuladores.

## Que resuelve

- Conserva datos de `Auth` entre sesiones del emulador.
- Conserva datos de `Firestore` entre sesiones del emulador.
- Evita la confusion de "desaparecieron mis grupos" por reiniciar emuladores sin persistencia.

## Nota sobre usuarios anonimos

Cada usuario anonimo tiene un `uid` distinto.  
La app lista grupos desde `user_groups/{uid}/groups`, por lo que:

- si cambias de usuario de prueba, veras otra lista de grupos;
- si mantienes el mismo usuario y usas emuladores persistentes, la lista se mantiene.
