class Cohort

  attr_reader :id

  def initialize()
    #TBD?
  end

  def self.insert_row(db, age, n)
    sql = <<-SQL
    INSERT INTO cohorts (age, n) VALUES (?, ?);
    SQL
    db.execute(sql, age, n)
    @id = db.execute("SELECT last_insert_rowid() FROM cohorts")[0][0]
  end
end
