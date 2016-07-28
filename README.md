# Ruby on the Rocks

## ORM on the Rocks

'ORM On The Rocks' uses customized SQL queries to take care of object relational mapping between your web app and your database. Supporting database searching bases on your own defined model associations.

## Getting Started

To get started:

**1** Clone this directory:
```bash
git clone https://github.com/eLZyBee/ruby-on-the-rocks.git
```
**2** cd into the ruby-on-the-rocks folder and replace the paths in `lib/orm_otr/db_link.rb` to your relevant .sql database in the root file. (Or use the `messages.sql` file provided by default.)
```ruby
# The messages.sql and messages.db may need changing.
MESSAGES_SQL_FILE = File.join(ROOT_FOLDER, 'messages.sql')
MESSAGES_DB_FILE = File.join(ROOT_FOLDER, 'messages.db')
```
**3** Load pry (or your preferred REPL) from the root folder and load your model as shown:
```ruby
$ pry
[1] pry(main)> load 'test_models/messages_model.rb'
=> true
[2] pry(main)> Message.all
=> [#<Message:0x007fa5243b6318 @attributes={:id=>1, :message=>"What's up everybody?", :user_id=>1}>,
 #<Message:0x007fa5243b6250 @attributes={:id=>2, :message=>"Just relaxing over here.", :user_id=>2}>]
```

**4** Create your own models in the style of the `messages_model.rb` in the test_models folder. Each class you define must end with the `finalize!` method in order to define the contained methods. This might look like the following:

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
# Retrieve all messages where user_id is 3.
Message.where(user_id: 3)

# Retrieve all messages.
Message.all

# Find a single message by an id.
Message.find(id)

```
