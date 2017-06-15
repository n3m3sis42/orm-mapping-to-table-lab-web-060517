require "pry"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.db
    # caching
    DB[:conn]
  end

  def self.create_table
    sql = <<~QUERY
        CREATE TABLE students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        );
      QUERY
    self.db.execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    self.db.execute(sql)
  end

  def db_record_id(name, grade)
    sql = "SELECT id FROM students WHERE name = ? AND grade = ?"
    values = [name, grade]
    self.class.db.execute(sql, values).flatten[0]
  end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
    values = [@name, @grade]
    self.class.db.execute(sql, values)
    @id = db_record_id(@name, @grade)
  end

  def self.create(new_student_hash)
    (student = Student.new(new_student_hash[:name], new_student_hash[:grade])).save
    student
  end

end
