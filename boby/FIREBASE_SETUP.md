# Configuración de Firebase Cloud Functions + SendGrid

## 📋 Resumen
Esta configuración permite enviar correos automáticos a los padres con las estadísticas de progreso de sus hijos en la app Boby.

## 🔧 Requisitos Previos

1. **Cuenta de Firebase Console**
   - Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Habilitar Firestore Database
   - Habilitar Authentication (opcional, si usas autenticación)

2. **Cuenta de SendGrid**
   - Crear cuenta en [SendGrid](https://sendgrid.com/)
   - Generar API Key
   - Verificar tu dominio de email

## 🚀 Pasos de Configuración

### 1. Configurar Firebase Project

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita **Firestore Database** en modo producción
4. Configura las reglas de seguridad (ver abajo)

### 2. Obtener Archivos de Configuración

#### Para Android:
```bash
# En Firebase Console > Project Settings > General
# Descarga google-services.json
# Colócalo en: android/app/
```

#### Para iOS:
```bash
# En Firebase Console > Project Settings > General
# Descarga GoogleService-Info.plist
# Colócalo en: ios/Runner/
```

#### Para macOS:
```bash
# En Firebase Console > Project Settings > General
# Descarga GoogleService-Info.plist
# Colócalo en: macos/Runner/
```

### 3. Configurar SendGrid

1. Ve a [SendGrid Dashboard](https://app.sendgrid.com/)
2. Settings > API Keys > Create API Key
3. Nombre: "Boby App Stats"
4. Permisos: "Mail Send"
5. Copia la API Key generada

### 4. Instalar Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

### 5. Configurar Firebase Functions

```bash
# En la raíz del proyecto
cd functions
npm install
cd ..

# Inicializar Firebase en el proyecto
firebase init functions
# Selecciona: JavaScript, Firestore, Pub/Sub
```

### 6. Configurar Variables de Entorno

```bash
# Establecer la API Key de SendGrid
firebase functions:config:set sendgrid.api_key="TU_API_KEY_AQUI"

# Verificar configuración
firebase functions:config:get
```

### 7. Deploy de Functions

```bash
# Deploy de todas las functions
firebase deploy --only functions

# Deploy solo de la función programada
firebase deploy --only functions:sendDailyStatsEmail
```

## 📊 Estructura de Datos en Firestore

### Colección `parents`
```javascript
{
  email: "padre@ejemplo.com",
  name: "Juan Pérez",
  childrenIds: ["child1", "child2"],
  createdAt: "2024-01-01T00:00:00.000Z",
  emailEnabled: true,
  frequency: "weekly" // "daily", "weekly", "monthly"
}
```

### Colección `children`
```javascript
{
  parentId: "padre@ejemplo.com",
  name: "Carlos",
  age: 7,
  createdAt: "2024-01-01T00:00:00.000Z"
}
```

### Colección `stats/{childId}/daily_stats/{date}`
```javascript
{
  childId: "child1",
  childName: "Carlos",
  parentId: "padre@ejemplo.com",
  date: "2024-01-01T00:00:00.000Z",
  wordsLearned: 15,
  levelsCompleted: 3,
  currentLevel: "Gold",
  score: 1500,
  gameProgress: {
    "memory": 5,
    "scramble": 3,
    "word_guess": 7
  },
  achievements: ["Primera palabra", "Nivel Gold alcanzado"]
}
```

## 🔒 Reglas de Seguridad de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Reglas para padres
    match /parents/{email} {
      allow read, write: if request.auth != null && request.auth.token.email == email;
    }
    
    // Reglas para hijos
    match /children/{childId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Reglas para estadísticas
    match /stats/{childId}/daily_stats/{date} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## 🧪 Testing Local

```bash
# Iniciar emuladores Firebase
firebase emulators:start

# Test local de la función
firebase functions:shell
sendDailyStatsEmail()
```

## 📅 Programación de Emails

La función `sendDailyStatsEmail` se ejecuta automáticamente:
- **Hora**: 8:00 PM (20:00)
- **Zona horaria**: America/Mexico_City
- **Frecuencia**: Diariamente

Para cambiar la programación, modifica el `cron schedule` en `functions/index.js`:
```javascript
// Ejemplos de cron schedules:
'0 20 * * *'        // Todos los días a las 8 PM
'0 20 * * 0'        // Todos los domingos a las 8 PM
'0 20 1 * *'        // El primer día de cada mes a las 8 PM
'0 */6 * * *'       // Cada 6 horas
```

## 🎨 Personalización del Email

Para personalizar el diseño del email, edita la función `sendStatsEmail` en `functions/index.js`:
- Cambiar colores del gradiente
- Modificar el layout
- Agregar más estadísticas
- Cambiar emojis y textos

## 🐛 Solución de Problemas

### Error: "SendGrid API Key not found"
```bash
# Configurar la API Key nuevamente
firebase functions:config:set sendgrid.api_key="TU_API_KEY"
firebase deploy --only functions
```

### Error: "Functions deployment failed"
```bash
# Verificar logs
firebase functions:log

# Revisar la versión de Node.js
node --version  # Debe ser 18 o superior
```

### Emails no llegan
1. Verificar que la API Key de SendGrid sea correcta
2. Revisar logs de Firebase Functions
3. Verificar que el email de destino sea válido
4. Revisar carpeta de spam en el email del destinatario

## 📞 Soporte

- Documentación Firebase: https://firebase.google.com/docs
- Documentación SendGrid: https://docs.sendgrid.com
- Guía Cloud Functions: https://firebase.google.com/docs/functions