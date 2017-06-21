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

  def get_drug_name(string)
     if string.include?("-use")
       string.chomp("-use")
     elsif string.include?("-frequency")
       string.chomp("-frequency")
     end
  end

   def get_drugs_array(data)
     drug_names = data[0].keys.map do |key|
       get_drug_name(key)
     end
     drug_names.compact.uniq
   end

   def clean_value(value)
     value == "-" ? 0.0 : value.to_f
   end

  ## NOTE: This function needs to return an array of drug_hashes!
  def parse_drug_data(row)
    drug_hash = {}
    x = row.each do |drug_key, value|
      # binding.pry
      if drug_key.include?("-use") #NOTE: THIS NEEDS TO BE REGEX ON USE/FREQUENCY
        name = get_drug_name(drug_key)
        drug_hash[name] = {}
        drug_hash[name]["use"] = clean_value(value)
      elsif drug_key.include?("-frequency")
        name = get_drug_name(drug_key)
        drug_hash[name]["frequency"] = clean_value(value)
      end
    end
    drug_hash
  end

  def enter_drug_data(data)
    drugs_array = get_drugs_array(data)
    drugs_array.each do |drug|
      Drug.insert_row(self.db, drug)
    end
  end

  def enter_data
    enter_drug_data(self.data)
    self.data.each do |row|
      cohort_id = Cohort.insert_row(self.db, row["age"], row["n"])
      drugs_hashes = parse_drug_data(row)
      binding.pry
      drug_id = Drug.find_id_by_name(self.db, drug_hash["drug_name"])
      #CohortsDrugs.insert_row(self.db, drug_hash["usage"], drug_hash["frequency"], cohort_id, drug_id)
    end
  end

end
