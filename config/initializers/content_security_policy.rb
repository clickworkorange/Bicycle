# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# TODO: We need to find some way to get around the inline CSS restriction for aspect-ratio,
# perhaps by cropping all images at upload to a set of predefined sizes and setting a CSS
# class instead (e.g. 3/4, 4/3, 2/3, 3/2, 16/9, 9/16). This would require finding the closest
# matching aspect ratio. We could simply divide w/h and look up the closest matching value
# e.g. 4/3 = 1.33333, 3/4 = 0.75, 3/2 = 1.5, 2/3 = 0.66666, 16/9 = 1.77777, 9.16 = 0.5625
# We would also need to redesign the header, perhaps using data-background-image and setting
# the content: property in the stylesheet. Nonces are not a good option.

Rails.application.configure do
  config.content_security_policy do |policy|
    # app/controllers/bicycle/application_controller.rb overrides script_src
    policy.default_src :self # , :https
    policy.font_src    :self # , :https, :data
    policy.img_src     :self, "https://avatars.githubusercontent.com" # , :https, :data
    policy.object_src  :none
    policy.script_src  :self # , :https
    policy.style_src   :self, :unsafe_inline # , :https
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  # config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  # config.content_security_policy_nonce_directives = %w(script-src style-src)

  #   # Report violations without enforcing the policy.
  #   # config.content_security_policy_report_only = true
end
