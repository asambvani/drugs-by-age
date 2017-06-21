class Query

  @@db = nil

  def initialize(db)
    self.class.db = db
    # sql_settings = <<-SQL
    # .header on
    # .mode column
    # .width auto
    # SQL
    # self.class.db.execute(sql_settings)
  end

  def self.db
    @@db
  end

  def self.db= (db)
    @@db = db
  end

  def see_queries
    Query.methods.grep("") #TODO complete this method
  end

  def self.cohort20_alcohol_data
    sql = <<-SQL
      SELECT cohorts_drugs.usage, cohorts_drugs.frequency
      FROM cohorts JOIN cohorts_drugs JOIN drugs
      ON cohorts.id = cohorts_drugs.cohort_id
      AND cohorts_drugs.drug_id = drugs.id
      WHERE cohorts.age = "20" AND drugs.name = "alcohol";
    SQL
    self.db.execute(sql)
  end

  def self.most_popular_drugs_by_cohort
    sql = <<-SQL
      SELECT drugs.name, cohorts.age, cohorts_drugs.usage
      FROM cohorts JOIN cohorts_drugs JOIN drugs
      ON cohorts.id = cohorts_drugs.cohort_id
      AND cohorts_drugs.drug_id = drugs.id
      GROUP BY cohorts.age
      HAVING MAX(cohorts_drugs.usage)
    SQL
    self.db.execute(sql)
  end

    def self.least_popular_by_cohort #TODO why does this not return cohorts with min drug usage values of 0.0?
      sql = <<-SQL
        SELECT drugs.name, cohorts.age, cohorts_drugs.usage
        FROM cohorts JOIN cohorts_drugs JOIN drugs
        ON cohorts.id = cohorts_drugs.cohort_id
        AND cohorts_drugs.drug_id = drugs.id
        GROUP BY cohorts.age
        HAVING MIN(cohorts_drugs.usage)
      SQL
      self.db.execute(sql)
    end

    def self.most_frequently_used_drugs_by_cohort
      sql = <<-SQL
        SELECT drugs.name, cohorts.age, cohorts_drugs.frequency
        FROM cohorts JOIN cohorts_drugs JOIN drugs
        ON cohorts.id = cohorts_drugs.cohort_id
        AND cohorts_drugs.drug_id = drugs.id
        GROUP BY cohorts.age
        HAVING MAX(cohorts_drugs.frequency)
      SQL
      self.db.execute(sql)
    end

end
