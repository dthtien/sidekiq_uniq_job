require_relative "./prof_gray/satellite_analysis"
require "active_record"
ActiveRecord::Base.establish_connection(adapter: "postgresql", database: "prof_greys_data")
class Result < ActiveRecord::Base
end

class DataProcessor
  include Sidekiq::Worker

  def perform(data, opts)
    result = Result.find_or_initialize_by(data: data, analysis_type: opts['type'])
    return if result.persisted?

    result.save!
    result.with_lock do
      return if result.reload.result.present?

      result.result = ProfGraySatelliteAnalysis::Analyzer.analyze_type(
        data, { 'type' => opts['type'] }
      )
      result.save!
    end
  rescue StandardError => e
    puts e.message
  end
end
