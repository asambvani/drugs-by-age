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

  ## NOTE: This function needs to return an array of drug_hashes!
  def parse_drug_data(row)
    data_array = row.map do |string, num|
      if string.include?("-") #NOTE: THIS NEEDS TO BE REGEX ON USE/FREQUENCY
        drug_hash = {}
        split_string = string.split("-")
        drug_hash["drug_name"] = split_string[0]
        drug_hash[split_string[1]] = num
      end
      drug_hash
    end
    data_array.compact
  end

  def enter_drug_data(data)
    drugs_array = get_drug_names(data)
    drugs_array.each do |drug|
      Drug.insert_row(self.db, drug)
    end
  end

  def enter_data
    enter_drug_data(self.data)
    self.data.each do |row|
      cohort_id = Cohort.insert_row(self.db, row["age"], row["n"])
      drugs_hashes_array = parse_drug_data(row)
      binding.pry
      drug_id = Drug.find_id_by_name(self.db, drug_hash["drug_name"])
      #CohortsDrugs.insert_row(self.db, drug_hash["usage"], drug_hash["frequency"], cohort_id, drug_id)
    end
  end

end
