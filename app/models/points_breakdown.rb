class PointsBreakdown < ActiveRecord::Base
  belongs_to :user

  def self.primary_key
    :id
  end

  def medal
    case rank
      when 1     then :gold
      when 2, 3  then :silver
      when 4..10 then :bronze
    end
  end
end
