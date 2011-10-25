require 'rspec/core/formatters/base_text_formatter'
require 'json'

class JsonFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def initialize(output)
    super

    @store = {}
  end

  def start(count)
    @store['count']  = count
    @store['passed'] = []
    @store['failed'] = []
  end

  def example_passed(example)
    @store['passed'] << example.full_description
  end

  def example_failed(example)
    @store['failed'] << example.full_description
  end

  def start_dump
    @output.puts @store.to_json
  end

  def dump_failures(*args); end
  def dump_failure(*args); end
  def dump_pending(*args); end
  def dump_summary(*args); end
end
