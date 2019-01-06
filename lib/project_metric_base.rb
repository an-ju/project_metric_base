require "project_metric_base/version"

module ProjectMetricBase
  attr_reader :raw_data
  class Error < StandardError; end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :credentials
    attr_accessor :data_names

    def meta
      { credentials: @credentials,
        raw_data: @data_names }
    end

    def add_credentials(new_credentials)
      @credentials = new_credentials
    end

    def add_raw_data(new_raw_data)
      @data_names = new_raw_data
    end
  end

  def refresh
    @raw_data = self.class.data_names.inject({}) do |dhash, d|
      dhash.update({ d: send(d) })
    end
  end

  def complete_with(new_data)
    return refresh if new_data.nil?

    @raw_data = {}
    self.class.data_names.each do |d|
      if new_data.has_key? d
        @raw_data[d] = new_data[d]
        instance_variable_set(('@'+d.to_s).to_sym, new_data[d])
      else
        @raw_data[d] = send(d)
      end
    end
  end

  def raw_data=(new_data)
    @raw_data = {}
    self.class.data_names.each do |d|
      @raw_data[d] = new_data[d]
      instance_variable_set(('@'+d.to_s).to_sym, new_data[d])
    end
    @raw_data
  end

  def image
    raise NotImplementedError
  end

  def score
    raise NotImplementedError
  end

  def obj_id
    raise NotImplementedError
  end

end
