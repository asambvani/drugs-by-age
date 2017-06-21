class CohortsDrugs

  attr_reader :id

  def initialize()
    #tbd
  end

  def self.insert_row(db, usage, frequency, cohort_id, drug_id)
    sql = <<-SQL
    INSERT INTO cohorts_drugs (usage, frequency, cohort_id, drug_id) VALUES (?, ?, ?, ?);
    SQL
    db.execute(sql, usage, frequency, cohort_id, drug_id)
    @id = db.execute("SELECT last_insert_rowid() FROM cohorts_drugs")[0][0]
  end
end
