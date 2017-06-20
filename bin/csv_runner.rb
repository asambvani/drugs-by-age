class CSVRunner

  attr_reader :file_name, :data, :db

  @@pwd = Dir.pwd

  def initialize(db, csv_file_name)
    @file_name = csv_file_name
    @db = db
  end

  def self.pwd
    @@pwd
  end

  def to_hash
    csv_raw_data = File.read(self.class.pwd + self.file_name)
    table = CSV.parse(csv_raw_data, :headers => true)
    @data = table.map {|row| row.to_hash}
  end

  def get_drug_names(data)
    drug_names = data[0].keys.map do |key|
      key.split("-")[0] if key.include?("-")
    end
    drug_names.compact.uniq
  end

  def enter_drug_data(data)
    drugs_array = get_drug_names(data)
    drugs_array.each do |drug|
      Drug.insert_row(self.db, drug)
    end
  end

  def enter_data
    self.data.each do |row|
      cohort_id = Cohort.insert_row(self.db, row["age"], row["n"])
    end
    enter_drug_data(self.data)
  end

end
