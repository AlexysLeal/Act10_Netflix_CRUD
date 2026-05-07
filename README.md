# xflutteralexis

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<img width="627" height="878" alt="image" src="https://github.com/user-attachments/assets/12eabcff-0746-43e3-af2c-f54954461623" />
<img width="628" height="872" alt="image" src="https://github.com/user-attachments/assets/4e89724c-556a-43e5-a2a1-be00a458c3f2" />
<img width="619" height="904" alt="image" src="https://github.com/user-attachments/assets/4a592759-8db6-42b9-b131-68546f6e908d" />




# Proyecto Final: Netflix Admin Panel (Gestión de Contenido)

## 1. Visión General y Estética "Cinematic"
Desarrollar una aplicación de gestión de catálogo inspirada en la interfaz de **Netflix**. El diseño debe ser inmersivo y moderno.
* **Colores:** Fondo negro profundo (`#000000`), detalles y botones en Rojo Netflix (`#E50914`), texto blanco y gris suave.
* **Tipografía:** Fuentes modernas, limpias y sin serifas (estilo *Helvetica* o *Inter*).
* **Interfaz:** Uso de tarjetas (Cards) con aspecto de póster vertical (relación de aspecto 2:3) y sombras suaves para dar profundidad.

## 2. Requisitos Técnicos
* **Firebase:** Configuración de **Cloud Firestore** para el catálogo y **Firebase Auth** para el acceso de administradores.
* **Proyecto Inicial:** Debe basarse en el demo inicial del contador funcionando.
* **Configuración:** Incluir archivo `google-services.json` y dependencias de Firebase en `pubspec.yaml`.
* **Entrega:** Link de GitHub mediante el archivo `enviargithub.dart`.

## 3. Modelos de Datos (Netflix System)

Deberás implementar estos modelos en la carpeta `lib/models/`:

### A. Modelo de Película (`lib/models/pelicula_model.dart`)
Este modelo gestiona los títulos del catálogo. **Nota:** Se añade el campo `urlPoster` para cumplir con el requisito de imágenes.

```dart
class Pelicula {
  final String idPelicula;
  final String nombre;
  final String genero;
  final String duracion;
  final double calificacion;
  final String urlPoster; // URL obligatoria para el arte de la película

  Pelicula({
    required this.idPelicula,
    required this.nombre,
    required this.genero,
    required this.duracion,
    required this.calificacion,
    required this.urlPoster,
  });

  factory Pelicula.fromMap(Map<String, dynamic> map) {
    return Pelicula(
      idPelicula: map['Id_pelicula'] ?? '',
      nombre: map['Nombre'] ?? '',
      genero: map['Genero'] ?? '',
      duracion: map['duracion'] ?? '',
      calificacion: double.tryParse(map['calificacion'].toString()) ?? 0.0,
      urlPoster: map['url_poster'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'Id_pelicula': idPelicula,
    'Nombre': nombre,
    'Genero': genero,
    'duracion': duracion,
    'calificacion': calificacion,
    'url_poster': urlPoster,
  };
}
```

### B. Modelo de Usuario Netflix (`lib/models/usuario_model.dart`)
Gestiona los perfiles de los administradores del catálogo.

```dart
enum PlanSuscripcion { basico, estandar, premium, admin }

class UsuarioNetflix {
  final String uid;
  final String nombrePerfil;
  final String email;
  final PlanSuscripcion plan;
  final String urlAvatar; // Imagen del perfil de usuario

  UsuarioNetflix({
    required this.uid,
    required this.nombrePerfil,
    required this.email,
    this.plan = PlanSuscripcion.admin,
    this.urlAvatar = '',
  });

  factory UsuarioNetflix.fromMap(Map<String, dynamic> map) {
    return UsuarioNetflix(
      uid: map['uid'] ?? '',
      nombrePerfil: map['nombre_perfil'] ?? '',
      email: map['email'] ?? '',
      plan: PlanSuscripcion.values.byName(map['plan'] ?? 'admin'),
      urlAvatar: map['url_avatar'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'nombre_perfil': nombrePerfil,
    'email': email,
    'plan': plan.name,
    'url_avatar': urlAvatar,
  };
}
```

## 4. Estructura de Pantallas
1.  **Login "Netflix Entry":** Pantalla oscura con el logo rojo, campos de texto minimalistas y validación con Firebase Auth.
2.  **Pantalla Inicial:** Bienvenida con el avatar del admin y un botón destacado: "Administrar Catálogo de Contenido".
3.  **CRUD "Content Manager":**
    * **Galería Visual:** Lista de películas mostrando los posters en alta calidad.
    * **Formulario de Edición:** Campos para modificar nombre, género, calificación y la **URL del póster** (con previsualización en tiempo real).

## 5. Notas y Entregables
* **Gestión de Imágenes:** Es obligatorio que la app consuma y muestre imágenes reales de posters de películas mediante URLs guardadas en Firestore.
* **Capturas de Pantalla:** Se deben incluir imágenes de la app mostrando el catálogo visual y el formulario de edición funcionando.
* **Funcionalidad:** El sistema debe realizar cambios reales (CRUD) en la base de datos de Firebase.

todo esto tomando en cuenta que se usara firebase studio y firesbase console
