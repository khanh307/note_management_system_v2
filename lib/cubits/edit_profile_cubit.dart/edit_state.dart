abstract class EditProfileState{}

class EditProfileInitial extends EditProfileState{}

class EditProfileLoading extends EditProfileState{}

class EditProfileSuccess extends EditProfileState{}

class EditProfileFaileure extends EditProfileState {
  final String error;
  EditProfileFaileure(this.error);
}