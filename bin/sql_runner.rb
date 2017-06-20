class SQLRunner

  attr_reader :db

  @@pwd = Dir.pwd

  def initialize(db)
    @db = db
  end

  def self.pwd
    @@pwd
  end

  def create_tables
    sql = File.read(self.class.pwd + "/app/schema.sql")
    #Split sql file into individual create statement
    #Each statment must be separated by two line breaks for this to work
    sql.split("\n\n").each do |sql|
      self.db.execute(sql)
    end
  end


end
