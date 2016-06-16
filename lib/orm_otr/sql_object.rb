require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    unless @instance_variables
      instance_variables = DBConnection.execute2(<<-SQL)
        SELECT * FROM #{self.table_name} LIMIT 1
      SQL
      @instance_variables = instance_variables.first.map(&:to_sym)
    end
    @instance_variables
  end

  def self.finalize!
    self.columns.each do |variable|
      define_method(variable) do
        attributes[variable]
      end
      define_method("#{variable}=".to_sym) do |assign|
        attributes[variable] = assign
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT #{table_name}.* FROM #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |object_hash|
      self.new(object_hash)
    end
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
      SELECT #{table_name}.* FROM #{table_name}
      WHERE #{table_name}.id = ?
    SQL
    parse_all(result).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name.to_sym)
      send("#{attr_name}=".to_sym, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  def insert
    cols = self.class.columns[1..-1]
    col_names = cols.join(', ')
    question_marks = (['?'] * cols.count).join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO #{self.class.table_name} (#{col_names})
      VALUES (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    cols = self.class.columns[1..-1].map { |var| var.to_s + ' = ?'}
    col_sets = cols.join(', ')
    DBConnection.execute(<<-SQL, *attribute_values.rotate)
      UPDATE #{self.class.table_name}
      SET #{col_sets}
      WHERE id = ?
    SQL
  end

  def save
    self.id ? self.update : self.insert
  end
end
