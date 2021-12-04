require_relative "./prof_gray/satellite_analysis"
require "active_record"
ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "prof_greys_data")
class Result < ActiveRecord::Base
end

class DataProcessor
  include Sidekiq::Worker

  def perform(data, opts)
    result = ProfGraySatelliteAnalysis::Analyzer.analyze_type(
      data, { 'type' => opts['type'] }
    )
    Result.create!(data: data, analysis_type: opts['type'], result: result)
  end
end
