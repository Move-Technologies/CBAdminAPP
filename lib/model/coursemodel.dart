class Course {
  final int id;
  final String name;
  final String description;
  final String level;
  final String salary;
  final String iconUrl;
  final String jobDesc;
  final String companiesHiring;
  final int jobsOpen;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.salary,
    required this.iconUrl,
    required this.jobDesc,
    required this.companiesHiring,
    required this.jobsOpen,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['course_id'],
      name: json['course_name'],
      description: json['course_description'],
      level: json['course_level'],
      salary: json['course_salary'],
      iconUrl: json['course_icon'],
      jobDesc: json['job_desc'],
      companiesHiring: json['companies_hiring'],
      jobsOpen: json['jobs_open'],
    );
  }
}
