class GoogleBusiness
  attr_accessor :id, :name, :address, :phone, :rating, :reviewers_count, :city, :state, :type

#create google_businesses table if it doesn't exist
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS google_businesses (
        id INTEGER PRIMARY KEY,
        name TEXT,
        address TEXT,
        phone INTEGER,
        rating INTEGER,
        reviewers_count INTEGER,
        city TEXT,
        state TEXT,
        type TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS google_businesses"
    DB[:conn].execute(sql)
  end

#after receiving information from google_scraper for a business, instantiate a googe_busines based on the attributes, and save it to db
  def initialize(attributes)
    attibutes.each {|key, value| self.send(("#{key}=", value))}
  end

#save an instances attribute to DB googles_businesses table if it doesn't already exist (by name, type, city and state)
  def save
    if !self.class.find_by_name_city_and_state(name, type, city, state)
      sql = <<-SQL
      INSERT INTO google_businesses (name, address, phone, rating, reviewers_count, city, state, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      SQL

      DB[:conn].execute(sql, name, address, phone, rating, reviewers_count, city, state, type)
    end
  end

#class method to retrive a businesse by its name, city and state
  def self.find_by_name_city_and_state(name, type, city, state)
    sql = <<-SQL
    SELECT FROM google_businesses WHERE name=?
                                    AND type=?
                                    AND city=?
                                    AND state=?
    SQL

    DB[:conn].execute(sql, name, type, city, state).first
  end

#class method to retrive a list of businesses by type, city and state
  def self.find_by_type_city_and_state(type, city, state)
    sql = <<-SQL
    SELECT * FROM google_businesses WHERE type=?
                                      AND city=?
                                      AND state=?
    SQL

    DB[:conn].execute(sql, type, city, state)
  end

end
