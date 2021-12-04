require "sidekiq"
Sidekiq.redis { |conn|
  conn.flushall
}

require "active_record"

ActiveRecord::Tasks::DatabaseTasks.drop(adapter: "postgresql", database: "prof_greys_data")
ActiveRecord::Tasks::DatabaseTasks.create(adapter: "postgresql", database: "prof_greys_data")

ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "prof_greys_data")
if !ActiveRecord::Base.connection.table_exists? 'results'
  ActiveRecord::Schema.define do
    create_table :results, force: true do |t|
      t.string :data
      t.string :analysis_type
      t.string :result

      t.index [:data, :analysis_type], unique: true
    end
  end
end

