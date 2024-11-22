class Purpose {
  final int id;
  final String description;

  Purpose({required this.id, required this.description});

  // Static list of purposes
  static final List<Purpose> _purposes = [
    Purpose(id: 1, description: 'FACILITATION/APPROPRIATE ACTION'),
    Purpose(id: 2, description: 'YOUR INFORMATION'),
    Purpose(id: 3, description: 'FOR APPROVAL'),
    Purpose(id: 4, description: 'REVIEW & COMMENT'),
    Purpose(id: 5, description: 'KINDLY SEE ME ABOUT THIS'),
    Purpose(id: 6, description: 'RECOMMENDATION'),
    Purpose(id: 7, description: 'COORDINATION WITH OFFICES CONCERNED'),
  ];

  // Static method to get the list of purposes
  static List<Purpose> getPurposes() => _purposes;
}
