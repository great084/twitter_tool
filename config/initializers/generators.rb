Rails.application.config.generators do |g|
  g.skip_routes true
  g.assets false
  g.stylesheets false
  g.helper false
  g.template_engine :erb
  g.test_framework :rspec,
                   fixtures: true,
                   view_specs: false,
                   routing_specs: false,
                   helper_specs: false,
                   controller_specs: false,
                   request_specs: true
end
