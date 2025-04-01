class Login {
  final String username;
  final String perfilUsuario;

  final bool estado;
  const Login(this.username, this.perfilUsuario, this.estado);

  Login.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        perfilUsuario = json['perfilUsuario'] as String,
        estado = json['estado'] as bool;

  Map<String, dynamic> toJson() => {
        'username': username,
        'perfilUsuario': perfilUsuario,
        'estado': estado,
      };
}

class UserLogeado {
  // Private constructor to prevent external instantiation.
  UserLogeado._();

  // The single instance of the class.
  static final UserLogeado _instance = UserLogeado._();

  // A property to store some data.
  String user = "";
  String perfilUsuario = "";
  int id = 0;
  bool isAdministrador = false;

  // A method to set the data.
  void setUser(String user) {
    this.user = user;
  }

  // A method to get the data.
  String getUser() {
    return user;
  }

  void setPerfilUsuario(String perfil) {
    perfilUsuario = perfil;
  }

  // A method to get the data.
  String getPerfil() {
    return perfilUsuario;
  }

  void setId(int id) {
    this.id = id;
  }

  int getId() {
    return id;
  }

  void setIsAdmin(bool isAdmin) {
    isAdministrador = isAdmin;
  }

  getIsAdministrador() {
    return isAdministrador;
  }

  // Factory constructor to provide access to the singleton instance.
  factory UserLogeado() {
    return _instance;
  }
}
