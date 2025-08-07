# Car Travel Manager 🚗

Una aplicación móvil tipo taxímetro desarrollada en Flutter para conductores independientes que operan fuera de plataformas como Uber/Bolt.

## 📱 Descripción

Car Travel Manager es una herramienta digital profesional que permite a los conductores registrar y gestionar viajes de manera transparente, brindando a los pasajeros un comprobante detallado del servicio prestado.

## ✨ Características Principales

- 🎯 **Completamente Offline** - No requiere conexión a internet
- ⏱️ **Cronómetro de Precisión** - Medición exacta del tiempo de viaje
- 🧾 **Tickets Profesionales** - Comprobantes claros para los pasajeros
- 📊 **Historial Completo** - Registro de todos los viajes realizados
- ⭐ **Sistema de Reseñas** - Auto-evaluación del conductor
- 🌙 **Modo Nocturno** - Interfaz adaptada para uso nocturno
- 📝 **Modificación en Tiempo Real** - Editar datos durante el viaje

## 🛠️ Tecnologías

- **Framework:** Flutter
- **Base de Datos:** SQLite (local)
- **Arquitectura:** BLoC Pattern
- **UI/UX:** Material Design 3
- **Plataforma:** Android (API 24+)

## 📋 Requerimientos del Sistema

- Android 7.0 (API nivel 24) o superior
- Mínimo 2GB de RAM
- Resolución de pantalla desde 720p hasta 1440p
- Espacio de almacenamiento: <50MB

## 🚀 Instalación

### Prerrequisitos
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Android SDK

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone git@github.com:vargascarlitos/car_travel_manager.git
   cd car_travel_manager
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

4. **Generar APK para producción**
   ```bash
   flutter build apk --release
   ```

## 📱 Pantallas Principales

### 1. Carga de Datos
- Ingreso de nombre del pasajero
- Establecimiento de tarifa (moneda paraguaya Gs)
- Selección de tipo de servicio

### 2. Previsualización
- Verificación de datos antes del inicio
- Botón deslizable para iniciar viaje

### 3. Viaje en Curso
- Cronómetro en tiempo real
- Animación de automóvil
- Modificación de datos durante el viaje

### 4. Ticket/Resultado
- Comprobante profesional del viaje
- Información completa del servicio

### 5. Auto Reseña
- Calificación con sistema de 5 estrellas
- Comentarios opcionales del conductor

### 6. Historial
- Lista de todos los viajes realizados
- Estadísticas de ganancias
- Detalle completo de cada viaje

## 🏗️ Arquitectura

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── themes/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## 🎨 Diseño

La aplicación sigue las directrices de **Material Design 3** con:
- Paleta de colores **Bolt** (`#34D186` como color primario)
- Tipografía **Roboto**
- Componentes nativos de Flutter
- Soporte para tema claro y oscuro

## 📊 Funcionalidades

### Gestión de Viajes
- ✅ Cronómetro de alta precisión
- ✅ Formateo automático de moneda paraguaya
- ✅ Validación de formularios en tiempo real
- ✅ Persistencia local con SQLite

### Experiencia de Usuario
- ✅ Interfaz intuitiva y profesional
- ✅ Navegación fluida con gestos
- ✅ Feedback visual y táctil
- ✅ Optimizado para uso durante la conducción

### Seguridad y Privacidad
- ✅ Datos almacenados localmente
- ✅ No requiere permisos de internet
- ✅ No necesita GPS ni sensores
- ✅ Interfaz segura para mostrar a pasajeros

## 🤝 Contribuciones

Este es un proyecto privado desarrollado para un cliente específico. Las contribuciones no están abiertas al público.

## 📄 Licencia

Este proyecto es propiedad privada. Todos los derechos reservados.

## 🏢 Contacto

**Desarrollador:** Carlos Vargas  
**Cliente:** Ariel  
**Proyecto:** Aplicación Taxímetro Flutter  

---

*Desarrollado con ❤️ en Flutter para conductores independientes*