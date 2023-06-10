class Validations {
  String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty";
    } else if (value.length < 10) {
      return "Phone number should have minimum 10 numbers";
    }
    return null;
  }

  String? boxNameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Box name cannot be empty";
    }
    return null;
  }

  String? areaValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Area name cannot be empty";
    }
    return null;
  }

  String? cityValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "City cannot be empty";
    }
    return null;
  }

  String? stateValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "State cannot be empty";
    }
    return null;
  }

  String? zipValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Zip code cannot be empty";
    } else if (value.length < 6) {
      return "Zip code should be of 6 digits";
    }
    return null;
  }

  String? username(String? value) {
    if (value == null || value.length < 3) {
      return "Username cannot be empty";
    }

    return null;
  }

  String? gmail(String? value) {
    if (value == null || value.length < 3) {
      return "Gmail cannot be empty";
    }

    return null;
  }
}
