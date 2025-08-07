# APLICACIÓN TAXÍMETRO - FLUTTER

## 1. INFORMACIÓN GENERAL DEL PROYECTO

### 1.1 Descripción del Proyecto
Desarrollo de una aplicación móvil tipo taxímetro para dispositivo Android, diseñada para conductor independiente que opera fuera de plataformas como Uber/Bolt. La aplicación proporcionará mayor confianza y profesionalismo a los clientes fidelizados mediante un sistema de medición de viajes transparente y confiable.

### 1.2 Objetivo Principal
Crear una herramienta digital que permita al conductor registrar y gestionar viajes de manera profesional, brindando a los pasajeros un comprobante detallado del servicio prestado.

### 1.3 Plataforma de Desarrollo
- **Framework:** Flutter
- **Plataforma objetivo:** Android
- **Tipo de aplicación:** Nativa móvil
- **Conectividad:** Completamente offline

## 2. REQUERIMIENTOS FUNCIONALES

### 2.1 Pantalla de Carga de Datos
- **RF-001:** La aplicación debe permitir el ingreso de los siguientes datos:
  - Nombre del pasajero (campo de texto obligatorio)
  - Monto total del viaje (campo numérico obligatorio con formato de moneda paraguaya Gs - entrada manual únicamente)
  - Tipo de servicio (selector con opciones: "Economy", "UberX", "Aire AC")
  - Botón para confirmar o guardar los datos cargados (botón estático, sin deslizar)
- **RF-002:** El sistema debe validar que todos los campos obligatorios estén completos antes de permitir confirmar los datos.
- **RF-003:** El campo de monto debe formatear automáticamente la entrada con separadores de miles y símbolo de moneda "Gs".
- **RF-004:** El campo de monto debe ser únicamente de entrada manual, sin opciones predeterminadas o sugerencias.

#### 2.1.1 Pantalla de Previsualización de Datos Cargados
- **RF-005:** Después de confirmar los datos en la pantalla anterior, la aplicación debe mostrar una pantalla de previsualización que contenga:
  - Nombre del pasajero cargado
  - Tipo de servicio seleccionado
  - Botón deslizable para iniciar el viaje (ubicado en la parte inferior)
  - No mostrar monto del viaje en esta pantalla
- **RF-006:** Esta pantalla permite al conductor verificar los datos antes de que el pasajero aborde el vehículo e iniciar el viaje cuando corresponda.

### 2.2 Pantalla de Viaje en Curso
- **RF-007:** La aplicación debe mostrar:
  - Identificador del viaje: "Viaje en Curso"
  - Cronómetro en tiempo real con formato HH:MM:SS (tamaño moderado, no muy grande)
  - Animación de un automóvil en movimiento
  - Botón deslizable para finalizar el viaje
  - Indicador visual (flecha hacia abajo) que sugiera la posibilidad de deslizar hacia abajo
- **RF-008:** El cronómetro debe iniciarse automáticamente al acceder a esta pantalla y mantener la precisión del tiempo transcurrido.
- **RF-009:** La aplicación debe mantener el cronómetro activo incluso si la pantalla se bloquea o la app pasa a segundo plano.
- **RF-010:** La pantalla debe permitir el gesto de deslizar hacia abajo (swipe down) para acceder a la modificación de datos del viaje.

#### 2.2.1 Pantalla de Modificación de Datos Durante el Viaje
- **RF-011:** Al realizar un swipe hacia abajo desde la pantalla de viaje en curso, la aplicación debe mostrar una pantalla de modificación que permita:
  - Editar el nombre del pasajero
  - Modificar el monto total del viaje
  - Cambiar el tipo de servicio (Economy, UberX, Aire AC)
  - Botón para guardar los cambios y regresar al cronómetro
- **RF-012:** Durante la modificación de datos, el cronómetro debe continuar corriendo en segundo plano sin interrupciones.
- **RF-013:** Al guardar los cambios, la aplicación debe regresar automáticamente a la pantalla de viaje en curso mostrando el cronómetro actualizado.

### 2.3 Pantalla de Ticket/Resultado
- **RF-015:** Al finalizar el viaje, la aplicación debe generar un ticket que muestre:
  - Encabezado personalizado con el nombre del pasajero
  - Monto total del viaje (con mayor prominencia visual)
  - Duración exacta del viaje (HH:MM:SS)
  - Tipo de servicio utilizado (estado final)
- **RF-016:** El ticket debe tener un diseño claro y profesional, fácil de leer para el cliente y el conductor. El monto debe ser el elemento más visible y prominente, ya que es la información de mayor importancia para el cliente. La jerarquía visual debe ser: Nombre del pasajero, seguido inmediatamente del monto en gran tamaño, y luego los demás datos complementarios.

#### 2.2.3 Pantalla de auto reseña.
- **RF-017:** Luego de finalizar la pantalla de Ticket se debe de mostrar una pantalla de auto reseña del viaje para que el conductor califique el viaje en modo de 5 estrellas.
  - Se despliegan 5 estrellas que el conductor puede seleccionar de 1 al 5 siendo 1 la peor referencia posible y 5 la mejor.
  - Se despliega una caja de texto para que el conductor pueda escribir comentarios adicionales que detallen la experiencia del viaje. Este campo de texto puede tener hasta 1000 caracteres alfanuméricos.
  - Botón para guardar la reseña.

### 2.4 Pantalla de Historial
- **RF-018:** La aplicación debe mantener un registro histórico de todos los viajes realizados.
- **RF-019:** El historial debe mostrar:
  - Fecha y hora de cada viaje
  - Nombre del pasajero (datos finales)
  - Duración del viaje
  - Monto cobrado (final, incluyendo modificaciones)
  - Tipo de servicio (final)
- **RF-020:** Los datos del historial deben persistir incluso después de cerrar y reabrir la aplicación.

### 2.5 Modo Nocturno
- **RF-021:** La aplicación debe incluir modo nocturno (tema oscuro) para facilitar su uso durante horas de poca luz.

## 3. REQUERIMIENTOS NO FUNCIONALES

### 3.1 Rendimiento
- **RNF-001:** La aplicación debe iniciar en menos de 3 segundos en dispositivos Android estándar.
- **RNF-002:** El cronómetro debe mantener precisión de centésimas de segundo.
- **RNF-003:** La aplicación debe funcionar fluidamente sin conexión a internet.

### 3.2 Usabilidad
- **RNF-004:** La interfaz debe seguir las directrices de Material Design 3.
- **RNF-005:** Los botones deslizables deben tener feedback visual y táctil.
- **RNF-006:** La aplicación debe ser intuitiva para usuarios con conocimientos básicos de smartphones.
- **RNF-007:** El tamaño de fuente debe ser legible en dispositivos con pantallas de 5" o mayores.
- **RNF-008:** El cronómetro debe tener un tamaño moderado para no dominar la pantalla.
- **RNF-009:** Los gestos de swipe deben ser fluidos y responsivos, con feedback visual adecuado.

### 3.3 Compatibilidad
- **RNF-010:** Compatibilidad con Android 7.0 (API nivel 24) o superior.
- **RNF-011:** Soporte para resoluciones de pantalla desde 720p hasta 1440p.
- **RNF-012:** Funcionamiento en dispositivos con mínimo 2GB de RAM.

### 3.4 Almacenamiento
- **RNF-013:** Los datos deben almacenarse localmente en la base de datos SQLite del dispositivo.
- **RNF-014:** La aplicación no debe requerir permisos de acceso a internet.
- **RNF-015:** El tamaño de la aplicación instalada no debe exceder los 50MB.

## 4. REQUERIMIENTOS TÉCNICOS

### 4.1 Arquitectura
- **RT-001:** Implementación del patrón de arquitectura BLoC (Business Logic Component) para gestión de estados.
- **RT-002:** Separación clara entre lógica de negocio y presentación.
- **RT-003:** Uso de widgets stateless donde sea posible para optimizar rendimiento.

### 4.2 Almacenamiento de Datos
- **RT-004:** Implementación de SQLite para persistencia de datos locales.
- **RT-005:** Estructura de base de datos normalizada para optimizar consultas.
- **RT-006:** Implementación de migraciones de base de datos para futuras actualizaciones.

### 4.3 Componentes Visuales
- **RT-007:** Integración de animaciones Lottie para el elemento visual del automóvil.
- **RT-008:** Uso de Material Design Components oficiales de Flutter.
- **RT-009:** Implementación de temas personalizados manteniendo consistencia visual (claro y oscuro).

### 4.4 Funcionalidades Específicas
- **RT-010:** Implementación de Timer y Stopwatch nativos de Dart para el cronómetro.
- **RT-011:** Validación de formularios con feedback inmediato al usuario.
- **RT-012:** Formateo automático de campos numéricos para moneda paraguaya.
- **RT-013:** Gestión de gestos de swipe y navegación fluida entre pantallas sin interrumpir el cronómetro.

## 5. RESTRICCIONES Y LIMITACIONES

### 5.1 Restricciones Técnicas
- No requiere conexión a internet
- No necesita integración con servicios externos
- No requiere geolocalización GPS
- No necesita cámara ni sensores del dispositivo

### 5.2 Restricciones de Diseño
- Interfaz debe ser simple y funcional
- Colores y elementos acordes a Material Design
- No requiere logo personalizado ni branding específico
- Debe soportar tanto tema claro como oscuro

### 5.3 Restricciones de Funcionalidad
- No incluye sistema de usuarios múltiples
- No requiere encriptación de datos sensibles
- No necesita backup en la nube
- No incluye funcionalidades de sharing o exportación

## 6. CASOS DE USO PRINCIPALES

### 6.1 Caso de Uso: Realizar un Viaje Completo
- **Actor:** Conductor
- **Precondición:** Aplicación instalada y funcionando
- **Flujo principal:**
  1. El conductor abre la aplicación
  2. Ingresa el nombre del pasajero
  3. Establece el monto de la tarifa (entrada manual)
  4. Selecciona el tipo de servicio (Economy, UberX, o Aire AC)
  5. Presiona el botón "Cargar datos"
  6. Se muestra la pantalla de previsualización donde figura el nombre del pasajero y el tipo de servicio
  7. Cuando el pasajero aborda el vehículo, desliza la barra de "Iniciar viaje"
  8. El cronómetro inicia automáticamente
  9. **[OPCIONAL]** Durante el viaje, si es necesario modificar datos:
     - Desliza hacia abajo desde la pantalla del cronómetro
     - Modifica nombre, monto o tipo de servicio según necesidad
     - Guarda los cambios y regresa al cronómetro (que siguió corriendo)
  10. Al finalizar el viaje, desliza "Finalizar viaje"
  11. Se genera el ticket con todos los datos finales
  12. El conductor realiza una auto-reseña del viaje.
  13. El viaje se guarda en el historial

### 6.2 Caso de Uso: Consultar Historial
- **Actor:** Conductor
- **Precondición:** Al menos un viaje registrado
- **Flujo principal:**
  1. El conductor accede al historial
  2. Visualiza la lista de viajes anteriores
  3. Puede revisar detalles de viajes específicos en otra pantalla donde estan todas los datos de ese viaje incluido la reseña

### 6.4 Caso de Uso: Modificar Datos Durante el Viaje
- **Actor:** Conductor
- **Precondición:** Viaje en curso con cronómetro activo
- **Flujo principal:**
  1. El conductor identifica la necesidad de modificar datos (desvío, cambio de servicio, parada adicional)
  2. Desliza hacia abajo desde la pantalla del cronómetro
  3. Accede a la pantalla de modificación de datos
  4. Edita los campos necesarios (nombre, monto, tipo de servicio)
  5. Confirma los cambios
  6. Regresa automáticamente a la pantalla del cronómetro
  7. Continúa con el viaje normalmente
- **Flujo alternativo:**
  - Si no se realizan cambios, puede regresar a la pantalla del cronómetro sin guardar

## 7. FLUJO DE PANTALLAS
**Secuencia de Navegación:**
1.  **Pantalla Principal** → Carga de datos del viaje
2.  **Pantalla de Previsualización** → Verificación de datos y preparación para inicio
3.  **Pantalla de Viaje en Curso** → Cronómetro activo y seguimiento del viaje
    - **3.1 Pantalla de Modificación** → (Accesible con swipe hacia abajo) Edición de datos sin detener cronómetro
4.  **Pantalla de Ticket** → Resultado final y comprobante
5.  **Pantalla de reseña** → Auto reseña del conductor
6.  **Pantalla de Historial** → Registro de viajes anteriores

## 8. ENTREGABLES

### 8.1 Entregables de Desarrollo
- Código fuente completo de la aplicación Flutter
- APK compilado y firmado para instalación
- Documentación técnica del código
- Estructura de base de datos local documentada

### 8.2 Entregables de Diseño
- Wireframes de todas las pantallas (incluyendo la nueva pantalla de previsualización y modificación de datos)
- Guía de estilo visual implementada (temas claro y oscuro)
- Assets gráficos utilizados (incluyendo indicadores visuales para gestos de swipe)

### 8.3 Entregables de Testing
- Casos de prueba ejecutados
- Pruebas de funcionalidad en ambos temas

## 9. CRITERIOS DE ACEPTACIÓN

### 9.1 Funcionalidad
- Todas las pantallas funcionan según especificaciones
- La pantalla de previsualización muestra correctamente los datos cargados
- El cronómetro mantiene precisión durante todo el viaje y tiene tamaño moderado
- La funcionalidad de swipe hacia abajo funciona correctamente
- La modificación de datos durante el viaje no interrumpe el cronómetro
- Los datos modificados se reflejan correctamente en el ticket final
- Los datos se almacenan correctamente en el historial
- Las validaciones de formulario funcionan apropiadamente
- La aplicación funciona completamente offline
- El modo nocturno funciona correctamente

### 9.2 Calidad
- La aplicación no presenta crashes durante uso normal
- La interfaz es responsive en diferentes tamaños de pantalla
- Los tiempos de respuesta son aceptables
- El diseño es consistente en todas las pantallas
- Ambos temas (claro y oscuro) mantienen legibilidad y usabilidad

### 9.3 Usabilidad
- La navegación es intuitiva para el usuario objetivo
- Los botones y controles responden adecuadamente
- Los gestos de swipe son fluidos y tienen feedback visual claro
- La información se presenta de manera clara y legible
- La aplicación es fácil de usar durante la conducción
- La pantalla de previsualización facilita la verificación de datos antes del inicio del viaje
- La modificación de datos durante el viaje es accesible y no interfiere con la conducción

---
*Documento para el desarrollo de aplicación taxímetro Flutter*
*Versión 3.0*
*Fecha de última actualización: Agosto 2025*
