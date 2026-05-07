enum PlanSuscripcion { basico, estandar, premium, admin }

class UsuarioNetflix {
  final String uid;
  final String nombrePerfil;
  final String email;
  final PlanSuscripcion plan;
  final String urlAvatar;

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
