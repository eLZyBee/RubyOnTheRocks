require_relative 'db_link'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{self.table_name}." + key.to_s + ' = ?'}.join(' AND ')
    
    result = DBLink.execute(<<-SQL, *params.values)
      SELECT * FROM #{self.table_name}
      WHERE #{where_line}
    SQL
    parse_all(result)
  end
end

class SQLObject
  extend Searchable
end
