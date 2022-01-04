enum Role {
  normalUser,
  admin,
  undefined
}

extension RoleExtension on Role {
  String getName() {
    return toString().split('.').last;
  }
}

extension StringExtension on String {
  Role toRole() {
    Role role;
    switch(this) {
      case 'normalUser':
        role = Role.normalUser;
        break;
      case 'admin':
        role = Role.admin;
        break;
      default:
        role = Role.undefined;
    }
    return role;
  }
}
