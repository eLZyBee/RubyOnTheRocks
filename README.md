# Ruby on the Rocks

## ORM on the Rocks

'ORM On The Rocks' uses customized SQL queries to take care of object relational mapping between your web app and your database. Supporting database searching bases on your own defined model associations.

## Getting Started

To get started, clone this directory and replace the paths in `lib/db_link.rb` to your relevant database. Or use the `messages.sql` file provided as default.

You can create your models in the style of the `messages_model.rb` in the test_models folder. Be sure to require `associatable.rb` by including the following at the top of your model file.

```ruby
require "../lib/orm_otr/associatable"
```

Each class you define must end with the `finalize!` method in order to defined the contained methods. This might look like the following:

```ruby
class Message < SQLObject
  belongs_to :user, foreign_key: :user_id

  finalize!
end
```

## Supported Associations

The following associations are supported 'On The Rocks':
`belongs_to`
`has_many`
`has_one_through`
All requiring the class table and pointer to the `foreign_key`.

## Supported Searches

You can query your models using the following terms to retrieve their information from the database.

```ruby
# Retrieve all messages starting with a capital B.
Message.where("message LIKE 'B%'")

# Retrieve all messages.
Message.all

# Find a single message by an id.
Message.find(id)

```
