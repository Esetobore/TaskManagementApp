class Validators {
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Returns null if valid, error message if invalid
  static String? validateTaskTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Task title is required';
    }

    if (title.length < 3) {
      return 'Task title must be at least 3 characters long';
    }

    if (title.length > 50) {
      return 'Task title cannot exceed 50 characters';
    }

    return null;
  }

  /// Returns null if valid, error message if invalid
  static String? validateTaskDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Task description is required';
    }

    if (description.length > 500) {
      return 'Description cannot exceed 500 characters';
    }

    return null;
  }

  /// Returns null if valid, error message if invalid
  static String? validateDueDate(DateTime? dueDate) {
    if (dueDate == null) {
      return 'Due date is required';
    }

    if (dueDate.isBefore(DateTime.now())) {
      return 'Due date cannot be in the past';
    }

    return null;
  }

  /// Returns null if valid, error message if invalid
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    if (username.length > 30) {
      return 'Username cannot exceed 30 characters';
    }

    // Only allow letters, numbers, and underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }
}
