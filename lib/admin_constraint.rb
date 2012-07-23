class AdminConstraint
  def matches?(request)
    request.env["warden"].authenticate? and request.env['warden'].user.admin?
  end
end
