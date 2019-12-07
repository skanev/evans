module AwardsContributions
  extend ActiveSupport::Concern

  def star_contribution(contribution, and_redirect_to: nil)
    contribution.star

    respond_to do |wants|
      wants.html { redirect_to and_redirect_to }
      wants.js { render json: {starred: true} }
    end
  end

  def unstar_contribution(contribution, and_redirect_to: nil)
    contribution.unstar

    respond_to do |wants|
      wants.html { redirect_to and_redirect_to }
      wants.js { render json: {starred: false} }
    end
  end
end
