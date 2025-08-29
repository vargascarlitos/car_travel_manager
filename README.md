# Car Travel Manager 🚗

Aplicación tipo taxímetro en Flutter con arquitectura Clean, offline-first y UI MD3 dark “Bolt”.

  <img src="https://github.com/user-attachments/assets/2f3a54bf-54c7-4efb-8b14-a286e732599b" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>

  <img src="https://github.com/user-attachments/assets/880a9c9d-1897-495c-82c6-42435999e1d0" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>

  <img src="https://github.com/user-attachments/assets/c0f482f8-8e06-47a3-9ba7-d2933c4b914b" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>

  <img src="https://github.com/user-attachments/assets/632e2153-257a-468c-88a1-3f9716f944fe" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>
  
  <img src="https://github.com/user-attachments/assets/6d257999-0303-40c4-9a0d-d1d743911f0c" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>

  <img src="https://github.com/user-attachments/assets/3a29b353-1b1b-4b57-aa37-92decf77b86b" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 57 59" width="200"/>

  <img src="https://github.com/user-attachments/assets/7504d622-bf08-42a0-9b3f-40aed4775d61" alt="Simulator Screenshot - iPhone SE (3rd generation) - 2024-09-20 at 00 58 19" width="200"/>

## ✨ Estado actual (entregable)

- Offline-first 100% (SQLite como única fuente de datos)
- Clean Architecture (data/domain/presentation) sin casos de uso, repositorios directos
- State management con flutter_bloc (Cubit/Bloc) + Formz (formularios)
- Theme MD3 “Bolt Dark” centralizado (usar siempre `Theme.of(context)`)
- Historial agrupado por día con secciones colapsables y paginación
- Paginación con `throttleDroppable` (stream_transform + bloc_concurrency)
- Protección de back con PopScope + confirmación en pantallas críticas
- Página de recuperación de viajes pendientes

## 🗂️ Estructura de carpetas

```
lib/
├── app_config/
│   ├── theme/              # Bolt Dark Theme (MD3)
│   ├── database/           # SQLite (helper, tablas, migraciones)
│   ├── router_config.dart  # Rutas (Navigator 1)
│   └── utils/              # Formatters y helpers
├── data/
│   ├── datasources/        # SQLite datasource
│   ├── models/             # Modelos persistencia
│   └── repositories/       # Implementaciones de repositorios
├── domain/
│   ├── entities/           # Entidades inmutables
│   └── repositories/       # Contratos abstractos
└── presentation/
    ├── bloc/               # Cubits/Blocs por feature
    ├── pages/              # Pages (Page→View→Components)
    └── widgets/            # Widgets reutilizables
```

## 🧭 Rutas y pantallas

- `/` NewTripPage (carga de datos)
- `/preview` PreviewPage (confirmación). PopScope de advertencia.
- `/trip-active` ActiveTripPage (viaje en curso, wakelock). PopScope de advertencia.
- `/trip-modify` ModifyTripPage (edición durante viaje)
- `/ticket` TicketPage (resumen). PopScope de advertencia.
- `/review` ReviewPage (auto-reseña). PopScope de advertencia.
- `/history` HistoryPage (agrupado por día, colapsable, paginado con throttle)
- `/trip-detail` TripDetailPage (detalle)
- `/pending-recovery` PendingRecoveryPage (recuperar viajes `pending`)

## 🏛️ Patrones de presentación (VGV-compliant)

- Page: StatelessWidget con BlocProvider + BlocListener (solo navegación/side-effects)
- View: StatelessWidget con Scaffold y layout
- Components: StatelessWidget privados + BlocBuilder con `buildWhen` específico
- Formz + Cubit State con `status` enum y `copyWith`

## 🗃️ Datos (SQLite)

- Tablas: `trips`, `reviews` con índices y triggers (ver `app_config/database/database_tables.dart`)
- Migraciones gestionadas en `database_migration.dart`
- Repositorio: `TripRepository` y `ReviewRepository` (contratos en domain, impl en data)

Semillas (demo):
- `DatabaseDemo.seedHistoryTrips(days: 7, perDay: 6)` crea viajes completados en varios días para probar agrupado.

## 🖌️ UI/Theme (Bolt Dark)

- Siempre usar `Theme.of(context)` para colores y tipografías
- Componentes MD3 ya configurados (AppBar, Card, Buttons, TextField, etc.)

## 📈 Historial optimizado

- Agrupado por día con cabeceras colapsables
- Paginación por `limit/offset` desde repositorio
- Scroll infinito con `NotificationListener`
- `HistoryBloc` usa `throttleDroppable(Duration(milliseconds: 700))`

## 🔐 Protecciones de UX

- PopScope con confirmación al volver atrás en: Preview, ActiveTrip, Ticket, Review
- Botón “warning” en NewTrip que abre `/pending-recovery` para retomar viajes `pending`

## 🔧 Versiones y ejecución (dev)

- Versiones recomendadas:
  - Flutter 3.24+ (SDK estable)
  - Dart 3.7+
  - Verifica tu instalación: `flutter --version`
- Pasos para ejecutar:
  - `flutter clean && flutter pub get`
  - Conecta un dispositivo/emulador y ejecuta: `flutter run`
  - Para listar dispositivos: `flutter devices`

## 🧪 Testing (lineamientos)

- Tests de Cubits/Blocs con `bloc_test`
- Widget tests en flujos críticos

## 📝 Convenciones de commits

- Angular Conventional Commits (español), ej.: `feat(history): agrupar por día con headers`

## 📄 Notas finales

- Arquitectura offline-first lista para futura sincronización
- Sin dependencias de red; datos locales 100%
