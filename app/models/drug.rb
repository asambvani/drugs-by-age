class Drug

  attr_reader :id

  def initialize

  end

  def self.insert_row(db, name)

    sql = <<-SQL
    INSERT INTO drugs (name) VALUES (?);
    SQL

    db.execute(sql,name)
    @id = db.execute("SELECT last_insert_rowid() FROM cohorts")[0][0]

  end

end
