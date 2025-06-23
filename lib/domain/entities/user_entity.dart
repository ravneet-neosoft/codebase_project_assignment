class UserEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });
  String get fullName => '$firstName $lastName';

  List<Object?> get props => [id, email, firstName, lastName, avatar];
}
