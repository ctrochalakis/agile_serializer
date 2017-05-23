require 'bundler/setup'

require 'logger'
require 'active_record'
require "minitest/autorun"
require "minitest/color"
require "minitest/focus"
require 'shoulda'
require 'json'
require 'ap'

lib = File.expand_path('../../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'agile_serializer'
require 'agile_serializer/active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test.db'
)
ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.logger = Logger.new('test.log')

[:users, :posts, :comments, :check_ins, :reviews].each do |table|
  ActiveRecord::Base.connection.drop_table table rescue nil
end

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.string :email
end

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text :content
  t.integer :user_id
  t.string :type
end

ActiveRecord::Base.connection.create_table :comments do |t|
  t.text :content
  t.integer :post_id
end

ActiveRecord::Base.connection.create_table :check_ins do |t|
  t.integer :user_id
  t.string :code_name
end

ActiveRecord::Base.connection.create_table :reviews do |t|
  t.string :content
  t.integer :reviewable_id
  t.string :reviewable_type
end

ActiveSupport.test_order = :random
