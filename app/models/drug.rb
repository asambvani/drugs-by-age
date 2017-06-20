class Drug

  attr_reader :id

  def initialize

  end

  def self.find_id_by_name(db, name)
    sql = <<-SQL
    SELECT id FROM drugs WHERE name = ?;
    SQL
    db.execute(sql, name)
  end

  def self.insert_row(db, name)

    sql = <<-SQL
    INSERT INTO drugs (name) VALUES (?);
    SQL

    db.execute(sql,name)
    @id = db.execute("SELECT last_insert_rowid() FROM drugs")[0][0]


  end

end
