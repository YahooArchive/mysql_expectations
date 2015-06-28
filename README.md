[![Build Status](https://travis-ci.org/yahoo/mysql_expectations.svg?branch=master)](https://travis-ci.org/yahoo/mysql_expectations)

# MySQL Expectations

The `mysql_expectations` gem makes it easy to write RSpec expectations for MySQL 
schemas and data.

**Continuous Delivery Testing for Databases**

I make changes to the structure of my databases in a Continuous Delivery pipeline
using Liquibase.  While this works great, it is hard for a human to understand
what the current structure of the database should be just by looking at the 
change log.  This can make it hard to successfully write new change log entries. 
Specs written using this gem document the intended outcome of running the Liquibase 
change log. This gives additional confidence that new change log entries will
be written correctly.

**Test First Development for Databases**

I also practice test first development for my database changes using this gem.
First, I write the specs to express the outcome I want.  For instance, I could
add a new expectation that a certain field exists.  Running the specs at this
point fail.   Next, I update the Liquibase change log.  I know that I have gotten 
the change right once the tests pass.

## Installation

Installation is pretty standard:

```
$ gem install mysql_expectations
```

or install it using `bundler` by adding `mysql_expectations` to your `Gemfile`:

```
group :development, :test do
  gem 'mysql_expectations', '~> 1.0'
end
```

and then download and install by running:

```
bundle install
```

## Usage

MySQL Expectations uses the information returned from the `mysqldump` command
as the actual values for your specs.  Here is a sample `mysqldump` command:

```
mysqldump --xml --no-data --all-databases \
  --host=${host} --port=${port} \
  --user=${user} -p > database_dump.xml
```

The only real requirement is the `--xml` option.  `mysqldump` has many other
options that can help you limit the scope of the data returned or improve
performance.  Understanding the nuances of the `mysqldump` command is left
as an exercise for the reader.

Here is an example of using this gem in a spec file:

```ruby
require 'mysql_expectations'

# So you don't have to specify the module name every time:
include MySQLExpectations

describe 'database order_tracking' do

  # Load the mysqldump xml and assign it to the `databases` variable:
  let :databases do
    MySQL.new(File.new('mysqldump.xml'))
  end

  # use your database name as a method on `databases`:
  subject { databases.order_tracking }

  # Express database-level expectations here:
  #
  it { is_expected.to only_have_tables('person', 'order') }

  describe 'the person table' do
    # use your table name as a method:
    subject { databases.order_tracking.person }
    
    # Express table level expectations here:
    #
    it { is_expected.to have_field('id').of_type('int(11)').not_nullable }
    it { is_expected.to have_field('first_name').of_type('varchar(50)').nullable }
    it { is_expected.to have_field('last_name').of_type('varchar(50)').nullable }
    ...
    expected_key = Key.new('PRIMARY', Key::UNIQUE, [
      KeyField.new('id', KeyField::ORDER_ASC)
    ])
    it { is_expected.to have_key(expected_key) }
  end
  
  describe 'the order table' do
    subject { databases.order_tracking.order }
    ...
  end
end
```

## Detailed Examples

Detailed examples for how to use this gem can be found in the Cucumber
[features](features) in this code base.

Each Cucumber feature file gives a complete rspec file template along with example
expectation scenarios.  For example, the [have_table_matcher.feature](features/RSpec Database Matchers/have_table_matcher.feature)
gives an rspec template in the Background clause:
 
```cucumber
Given the rspec template for "database_spec.rb":
  """ruby
  require 'mysql_expectations'

  include MySQLExpectations

  describe 'database order_tracking' do
    let :databases do
      MySQL.new(File.new('mysqldump.xml'))
    end

    describe 'table item' do
      subject { databases.order_tracking.item }

      # Replace the following with your expectation(s):
      #
      <%= expectation %>
    end
  end
  """
```

Each scenario for this feature gives an expectation that you can plug into this rspec template:

```cucumber
  Scenario: expect database to have table
    Given the expectation:
      """ruby
      it { is_expected.to have_table('order') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have table 'order'"
```

All the features follow this same format.


Code licensed under the New BSD license. See the [LICENSE](LICENSE) file for terms.