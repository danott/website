<template data-parse>2021-10-07 #ruby</template>

# How I write to readonly databases in tests

We have a Rails app with two databases.
There's the primary database, which is all fine and good.
Normal CRUD (create/read/update/delete) life.
We have a secondary database with a readonly connection.
CRUD without the CUD.
Just the reads.

This is all fine and good, too.
It's easy enough to define our records to be readonly.
The username/password provided in `database.yml` establishes a readonly connection at the database level.
We reinforce the database level permissions within the Ruby runtime using the `ActiveRecord::Base#readonly?` convention.

```ruby
class SecondaryDatabaseRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to(:secondary_database)

  def readonly?
    true
  end
end

class Person < SecondaryDatabase
end
```

But what happens in tests, where we need to write test data?
On the database side, the user in `database.yml` can have a read connection.
But what about the Ruby side?

One approach is to put this knowledge into the class.

```ruby
def readonly?
  !Rails.env.test
end
```

With that little change, I can write `Person.create!(name: "Jake Peralta")` in my tests.

I don't like this.

Writing to a readonly database should feel surprising.
The readonly record should be naive of the environment.
It should just read data.

I want writing to the readonly database to stick out like a sore thumb.
The code I want to write in my tests is this:

```ruby
Person.mutate_test_data do
  Person.create!(name: "Jake Peralta")
end
```

So instead of changing the production system, I throw this little concern in `test_helper.rb`

```ruby
SecondaryDatabaseRecord.concerning "MutateTestData" do
  MUTATE_TEST_DATA_CALLS = []

  class_methods do
    def mutate_test_data
      MUTATE_TEST_DATA_CALLS.push(nil)
      yield
    ensure
      MUTATE_TEST_DATA_CALLS.pop
    end
  end

  included do
    undef :readonly?
    define_method :readonly? do
      MUTATE_TEST_DATA_CALLS.size.zero?
    end
  end
end
```

This little stack allows nesting calls to `mutate_test_data`.
Within this eyesore of a block, mutating test data is allowed.
Outside of the block, the readonly reality is relied upon, just like production.

I like this approach to tests assuming the posture of a servant toward the production system.
It reinforces the reality relied upon for stability in the real world.