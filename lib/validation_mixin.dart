

mixin ValidationMixin {


  String? validateName(String? value){
    if(value!.length<2){
      return 'Name should be at least 2 letters';
    }
    if(value.contains(RegExp(r'[0-9]'))){
      return 'Name should not contain numbers';
    }
    return null;
  }
// validates if password is at least 8 characters and at most 16 characters
  String? validatePassword(String? value) {
    if (value!.length < 8 || value.length > 16) {
      return 'Password should be between 8 and 16 characters';
    }
    return null;
  }
  
  String? validateEmail(String? value) {
    if (!value!.endsWith('@eng.asu.edu.eg')) {
      return 'Please enter a faculty email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    RegExp numeric = RegExp(r'^[0-9]+$');
    if (value!.length < 9 || value.length > 12) {
      return 'Number should be between 9 and 13 characters';
    }
    if (numeric.hasMatch(value)) {
      return null;
    }
    return 'Please enter digits only';
  }

  String? validteSignInPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }


}
