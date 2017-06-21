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

    def self.most_users_by_drug
      sql = <<-SQL
        SELECT drugs.name, cohorts.age, cohorts_drugs.usage
        FROM cohorts JOIN cohorts_drugs JOIN drugs
        ON cohorts.id = cohorts_drugs.cohort_id
        AND cohorts_drugs.drug_id = drugs.id
        GROUP BY drugs.id
        HAVING MAX(cohorts_drugs.usage)
      SQL
      self.db.execute(sql)
    end

    def self.most_frequent_users_by_drug
      sql = <<-SQL
        SELECT drugs.name, cohorts.age, cohorts_drugs.frequency
        FROM cohorts JOIN cohorts_drugs JOIN drugs
        ON cohorts.id = cohorts_drugs.cohort_id
        AND cohorts_drugs.drug_id = drugs.id
        GROUP BY drugs.id
        HAVING MAX(cohorts_drugs.frequency)
      SQL
      self.db.execute(sql)
    end

    def self.drug_names
      sql = <<-SQL
      SELECT drugs.name FROM drugs
      SQL
      self.db.execute(sql).map {|drug_array| drug_array[0]}
    end

    def self.cohorts_drugs_columns
      sql = <<-SQL
      PRAGMA table_info(cohorts_drugs)
      SQL
      self.db.execute(sql).map{|column_info| column_info[1]}
    end

    def self.cohorts
      sql = <<-SQL
      SELECT cohorts.age FROM cohorts
      SQL
      self.db.execute(sql).map {|age_array| age_array[0]}
    end

    def self.valid_drug_name?(drug_name)
      self.drug_names.include?(drug_name) ? drug_name : false
    end

    def self.valid_cohorts_drugs_columns?(column)
      self.cohorts_drugs_columns.include?(column) ? column : false
    end

    def self.valid_cohort?(cohort)
      self.cohorts.include?(cohort) ? cohort : false
    end

    def self.measure_by_drug(drug_name, measure)
      if !self.valid_drug_name?(drug_name) || !self.valid_cohorts_drugs_columns?(measure)
        if !self.valid_drug_name?(drug_name)
          "Error: invalid drug_name: #{drug_name}"
        elsif !self.valid_cohorts_drugs_columns?(measure)
          "Error: invalid measure: #{measure}"
        end
      else
        sql = <<-SQL
        SELECT cohorts.age, cohorts_drugs.#{measure}, drugs.name
        FROM cohorts JOIN cohorts_drugs JOIN drugs
        ON cohorts.id = cohorts_drugs.cohort_id AND
        cohorts_drugs.drug_id = drugs.id
        WHERE drugs.name = ?;
        SQL
        self.db.execute(sql, drug_name)
      end
    end

end
