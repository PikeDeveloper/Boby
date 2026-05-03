#!/bin/bash
# Build optimizado para Flutter Web

set -e

echo "🚀 Iniciando build optimizado..."

# Limpiar build anterior
flutter clean

# Obtener dependencias
flutter pub get

# Build con WASM para mejor rendimiento (Flutter 3.22+)
echo "📦 Compilando con WASM (más rápido)..."
flutter build web --release \
  --wasm \
  --web-renderer canvaskit \
  --dart-define=FLUTTER_WEB_USE_SKIA=true \
  --no-tree-shake-icons 2>&1 || \
flutter build web --release \
  --web-renderer canvaskit \
  --no-tree-shake-icons

echo "🗑️  Eliminando archivos innecesarios..."

# Eliminar NOTICES (28MB de licencias - no necesario en producción)
rm -f build/web/assets/NOTICES

# Eliminar archivos de fuentes no usadas
rm -f build/web/canvaskit/canvaskit.wasm 2>/dev/null || true

# Optimizar imágenes si existe npx
if command -v npx &> /dev/null; then
    echo "🖼️  Optimizando imágenes..."
    find build/web/assets -name "*.png" -exec npx imagemin {} --out-dir=$(dirname {}) \; 2>/dev/null || true
fi

echo "📊 Tamaño final:"
du -sh build/web

echo "✅ Build optimizado completado!"
echo "🚀 Listo para desplegar: firebase deploy --only hosting"
