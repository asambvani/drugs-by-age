class CSVRunner

  attr_reader :file_name
  @@pwd = Dir.pwd

  def initialize(csv_file_name)
    @file_name = csv_file_name
  end

  def self.pwd
    @@pwd
  end

  def to_hash
    csv_raw_data = File.read(self.class.pwd + self.file_name)
    table = CSV.parse(csv_raw_data, :headers => true)
    parsed_data = table.map {|row| row.to_hash}
  end
end
