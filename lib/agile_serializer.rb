module AgileSerializer

  if defined?(Rails) and Rails::VERSION::MAJOR >= 3
    require 'agile_serializer/railtie'
  end

  def self.extended(base)
    base.class_attribute(:serializer_configuration)
    base.class_attribute(:serializer_options)
  end

  def serialize_with_options(set = :default, &block)
    configuration = self.serializer_configuration.try(:dup) || {}
    options       = self.serializer_options.try(:dup) || {}

    configuration[set] = Config.new(configuration).instance_eval(&block)

    self.serializer_configuration = configuration
    self.serializer_options = options

    include InstanceMethods
  end

  def serialization_configuration(set)
    configuration = self.serializer_configuration
    conf = if configuration
      configuration[set] || configuration[:default]
    end

    conf.try(:dup) || { :methods => nil, :only => nil, :except => nil }
  end

  def serialization_options(set)
    options = self.serializer_options

    options[set] ||= serialization_configuration(set).tap do |opts|
      includes = opts.delete(:includes)

      if includes
        opts[:include] = includes.inject({}) do |hash, class_name|
          if class_name.is_a? Hash
            hash.merge(class_name)
          else
            begin
              true_name = reflections[class_name].options[:class_name] || class_name
              klass = true_name.to_s.classify.constantize
              hash[class_name] = klass.serialization_options(set)
              hash
            rescue NameError
              hash.merge(class_name => { :include => nil })
            end
          end
        end
      end
    end

    self.serializer_options = options
    options[set]
  end

  class Config
    undef_method :methods
    Instructions = [:skip_instruct, :dasherize, :skip_types, :root_in_json].freeze

    def initialize(conf)
      @conf = conf
      @data = { :methods => nil, :only => nil, :except => nil }
    end

    def method_missing(method, *args)
      @data[method] = Instructions.include?(method) ? args.first : args
      @data
    end

    def inherit(set)
      raise "Not known configuration!" unless @conf[set]
      @data = @conf[set].dup
    end

  end

  module InstanceMethods
    def to_xml(opts = {})
      set, opts = parse_serialization_options(opts)
      super(self.class.serialization_options(set).deep_merge(opts))
    end

    def as_json(opts = nil)
      opts ||= {}
      set, opts = parse_serialization_options(opts)
      ser_opts = self.class.serialization_options(set)

      super(ser_opts.deep_merge(opts))
    end

    private

    def parse_serialization_options(opts)
      if set = opts[:flavor]
        new_opts = {}
        root = opts[:root] and new_opts.merge!(:root => root)
      else
        set = :default
        new_opts = opts
      end

      [set, opts]
    end
  end
end
