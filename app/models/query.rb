class Query

  @@db = nil

  def initialize(db)
    self.class.db = db
  end

  def self.db
    @@db
  end

  def self.db= (db)
    @@db = db
  end

  def self.query1
    sql = <<-SQL
      SELECT cohorts_drugs.usage, cohorts_drugs.frequency
      FROM cohorts JOIN cohorts_drugs JOIN drugs
      ON cohorts.id = cohorts_drugs.cohort_id
      AND cohorts_drugs.drug_id = drugs.id
      WHERE cohorts.age = "20" AND drugs.name = "alcohol";
    SQL
    self.db.execute(sql)
  end



end
