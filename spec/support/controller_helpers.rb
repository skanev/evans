module Support
  module ControllerHelpers
    module ClassMethods
      def log_in_as(role)
        attributes = case role
          when :student then {admin?: false}
          when :admin then {admin?: true}
          else raise "Unknown role: #{role}"
        end

        let(:current_user) { double(attributes) }

        before do
          controller.stub current_user: current_user
        end
      end
    end

    RSpec::Matchers.define :deny_access do
      match do |response|
        response.request.flash[:alert].present? and response.redirect_url == 'http://test.host/'
      end

      failure_message_for_should { |response| "expected action to deny access" }
    end

    def self.included(example_group)
      example_group.extend ClassMethods
    end
  end
end
