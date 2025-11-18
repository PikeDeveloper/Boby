#!/bin/bash

# Navegar al directorio raíz del proyecto
cd "$(dirname "$0")"

# Limpiar el proyecto
echo "🧹 Limpiando el proyecto..."
flutter clean

# Construir el APK para Amazon
echo "🚀 Construyendo el APK para Amazon Appstore..."

# Construir el APK con las configuraciones específicas para Amazon
cd android
./gradlew clean assembleRelease
cd ..

# Crear el directorio de release si no existe
mkdir -p amazon_release/release

# Obtener la fecha actual
FECHA_ACTUAL=$(date +%Y%m%d)

# Copiar los APKs generados al directorio de release
cp android/app/build/outputs/apk/release/app-armeabi-v7a-release.apk "amazon_release/release/boby-armeabi-v7a-${FECHA_ACTUAL}.apk"
cp android/app/build/outputs/apk/release/app-arm64-v8a-release.apk "amazon_release/release/boby-arm64-v8a-${FECHA_ACTUAL}.apk"

# Crear un APK universal (opcional, solo si es necesario)
echo "🔧 Creando APK universal..."
cd amazon_release/release/
mkdir -p temp
unzip -j "boby-armeabi-v7a-${FECHA_ACTUAL}.apk" lib/armeabi-v7a/libapp.so -d temp/armeabi-v7a
unzip -j "boby-arm64-v8a-${FECHA_ACTUAL}.apk" lib/arm64-v8a/libapp.so -d temp/arm64-v8a

# Crear directorios necesarios
mkdir -p temp/lib/armeabi-v7a
mkdir -p temp/lib/arm64-v8a

# Mover las librerías a sus respectivos directorios
mv temp/armeabi-v7a/libapp.so temp/lib/armeabi-v7a/ 2>/dev/null || true
mv temp/arm64-v8a/libapp.so temp/lib/arm64-v8a/ 2>/dev/null || true

# Si hay archivos en los directorios, crear el APK universal
if [ -d "temp/lib/armeabi-v7a" ] || [ -d "temp/lib/arm64-v8a" ]; then
    cd temp
    zip -r "../boby-universal-${FECHA_ACTUAL}.apk" *
    cd ..
    
    # Limpiar archivos temporales
    rm -rf temp
    
    echo "✅ ¡APK universal creado exitosamente!"
else
    echo "⚠️ No se pudieron extraer las librerías nativas. Se generaron solo los APKs específicos por ABI."
fi

# Volver al directorio raíz
cd ../../

echo ""
echo "✅ ¡Proceso de construcción completado!"
echo "📁 Ubicación de los archivos generados:"
ls -lh amazon_release/release/
