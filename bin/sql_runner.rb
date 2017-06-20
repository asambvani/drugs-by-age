class SQLRunner

  @@pwd = Dir.pwd

  def initialize(db)
    @db = db
  end

  def self.pwd
    @@pwd
  end

  def create_tables
    sql = File.read(self.class.pwd + "/app/schema.sql")
  end


end
