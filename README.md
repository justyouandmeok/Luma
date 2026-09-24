# Onda — música de YouTube

App Flutter para **buscar y reproducir videos de YouTube** (categoría Música) con el **reproductor oficial** (IFrame). No descarga audio ni evade restricciones de YouTube.

## Qué hace falta (no es Firebase)

Firebase **no habilita** YouTube. Lo que necesitás es **YouTube Data API v3**:

1. Entrá a [Google Cloud Console](https://console.cloud.google.com/).
2. Creá un proyecto (podés usar el mismo que Firebase).
3. **APIs y servicios → Biblioteca → YouTube Data API v3 → Habilitar**.
4. **Credenciales → Crear credenciales → Clave de API**.
5. Restringí la key:
   - Tipo: aplicaciones Android
   - Nombre del paquete: `com.onda.music`
6. En la app: **Ajustes → pegar API key → Guardar**.

Cuota gratuita típica: 10.000 unidades/día (una búsqueda ~100 unidades).

## Firebase (opcional, después)

Sirve solo para:
- Cuentas (email)
- Playlists en la nube

No hace falta para ver o buscar videos.

## Cómo generar el proyecto Android/iOS

En tu PC o en este entorno:

```bash
flutter create --org com.onda --project-name onda onda_build
# copiá la carpeta lib/ y el pubspec.yaml de este zip encima
cd onda_build
flutter pub get
flutter run
```

O desde esta carpeta, si ya tenés `android/` generado:

```bash
flutter pub get
flutter build apk --release
```

`android/app/src/main/AndroidManifest.xml` debe incluir:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Límites importantes

- El video se ve **dentro del player oficial de YouTube** (con su UI).
- No se puede extraer solo el MP3 de forma permitida.
- YouTube Music no tiene API pública equivalente a Spotify.
- Si la API key no está restringida bien, Google puede bloquearla.
