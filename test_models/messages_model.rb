require_relative "../lib/orm_otr/sql_object"

# Classes provided for demonstration purposes.

# Build up your own classes in the style of the following and utilize the
# associatable methods as needed.

class Message < SQLObject
  belongs_to :user, foreign_key: :user_id

  finalize!
end

class User < SQLObject
  self.table_name = 'users'

  has_many :messagees, foreign_key: :user_id
  belongs_to :place

  finalize!
end

class Place < SQLObject
  has_many :users

  finalize!
end
