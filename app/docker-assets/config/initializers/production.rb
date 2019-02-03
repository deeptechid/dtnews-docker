class << Rails.application
  def domain
    ENV["DTNEWS_HOSTNAME"]
  end

  def name
    ENV["DTNEWS_SITE_NAME"]
  end
end

Rails.application.routes.default_url_options[:host] = Rails.application.domain
