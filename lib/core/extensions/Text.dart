extension CapitalizeExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;

    return this
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String getFileName() {
    String fileName = this.split('/').last;
    return fileName;
  }

  String getTruncatedFilenameWithDots() {
    final uri = Uri.parse(this);
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return '';
    }
    String filenameWithExtension = segments.last.toLowerCase();

    if (filenameWithExtension.length > 22) {
      String extension = filenameWithExtension.split('.').last;
      String baseName = filenameWithExtension.split('.').first;

      // Calculate max length for base name to keep total length within 10 including ".."
      int maxBaseLength = 22 - extension.length - 2; // Subtract 2 for ".."

      // Ensure base name doesn't exceed calculated max length
      if (maxBaseLength > 0) {
        baseName = baseName.substring(0, maxBaseLength);
        filenameWithExtension = '$baseName..$extension';
      } else {
        // If extension itself is too long or base name can't fit, truncate entire name to 10
        filenameWithExtension = filenameWithExtension.substring(0, 22);
      }
    }

    return filenameWithExtension;
  }

  String getFileExtension() {
    final uri = Uri.parse(this);
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return '';
    }
    String filenameWithExtension = segments.last.toLowerCase();
    return filenameWithExtension.split('.').last;
  }

  String formatDate() {
    final List months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    // Split the date string into parts
    final parts = this.split("T")[0].split("-");

    // Extract year, month, and day
    final year = int.parse(parts[0]);
    final month = months[int.parse(parts[1]) - 1];
    final day = int.parse(parts[2]);

    // Format the date as "DD Mon YYYY"
    return '$day $month $year';
  }

  String lastCharacters(int count) {
    if (count >= this.length) {
      return this;
    } else {
      return this.substring(this.length - count);
    }
  }

  String firstCharacters(int count) {
    if (count >= this.length) {
      return this;
    } else {
      return this.substring(0, count) + "...";
    }
  }
}

extension SecondsToMinutesExtension on num {
  double toMinutes() {
    double minutes = this / 60;
    return double.parse(minutes.toStringAsFixed(3));
  }
}
