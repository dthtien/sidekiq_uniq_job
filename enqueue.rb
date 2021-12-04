require "sidekiq/client"
require "sidekiq/api"
require_relative "./prof_gray/satellite_analysis"
require_relative "./prep_env"
require_relative "./app"

Result.destroy_all

client = Sidekiq::Client.new

data = [
  "4b5a43498edfc5a7f1fcff79b9d3c9e3",
  "4497923beb48187c306ed1b30ab43b1f",
  "6499315559174e4f288f2bfaf8937d43",
  "9abcbc269cc8c38fa6f401b0ab1906b9",
  "c8e8e37236b8593bde1967e1fa4ae343"
]

data.each do |datum|
  %w[a b c d].each do |type|
    5.times do # this part simulates the data source enqueueing multiple times
      client.push({
        "queue" => "default",
        "class" => "DataProcessor",
        "args" => [
          datum,
          {"type" => type}
        ]
      })
    end
  end
end

STDOUT.flush
stats = Sidekiq::Stats.new
end_time = Time.now + 15
while Time.now <= end_time
  stats.fetch_stats!
  sleep(1)
  if stats.retry_size > 0
    puts Sidekiq::RetrySet.new.each { |j| puts j.item }
    puts "Failure - at least one job failed."
    break
  end
end

if stats.enqueued > 0
  puts "Failure - not all jobs processed!"
else
  puts "Success - all jobs processed."
end

puts "Count of processed results in DB (there should be 20):"
puts Result.count
puts "Hash of all processed data:"
puts Digest::MD5.hexdigest(Result.all.order("data ASC, result ASC").pluck(:data, :result).flatten.join)
