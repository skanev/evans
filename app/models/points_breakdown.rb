class PointsBreakdown
  def self.field(name, type)
    @fields ||= []
    @fields.append name

    attr_reader name
    define_method "#{name}=" do |value|
      converted = case type.name
        when 'Integer' then value.to_i
        when 'String'  then value
        when 'Array'   then value.tr('{}', '').split(',').map(&:to_i)
      end

      instance_variable_set "@#{name}", converted
    end
  end

  field :id, Integer
  field :rank, Integer
  field :challenges, Integer
  field :vouchers, Integer
  field :attributions, Integer
  field :stars, Integer
  field :photo, Integer
  field :total, Integer
  field :name, String
  field :faculty_number, String
  field :tasks_breakdown, Array
  field :quizzes_breakdown, Array

  def initialize(hash = {})
    hash.each do |key, value|
      send "#{key}=", value
    end
  end

  def medal
    case rank
      when 1     then :gold
      when 2, 3  then :silver
      when 4..10 then :bronze
    end
  end

  class << self
    def find(user_id)
      hash = query("id = #{user_id.to_i}").first
      raise "Cannot find user with id = #{user_id}" if hash.nil?
      new hash
    end

    def count
      result = execute "SELECT COUNT(*) AS count FROM points_breakdowns"
      result.to_a.first['count'].to_i
    end

    def all
      query.to_a.map { |hash| new hash }
    end

    private

    def query(conditions = nil)
      sql = "SELECT #{@fields.join(', ')} FROM points_breakdowns"
      sql << " WHERE #{conditions}" if conditions
      execute sql
    end

    def execute(sql)
      ActiveRecord::Base.connection.execute sql
    end
  end
end
