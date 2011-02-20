module Support
  module ControllerHelpers
    module ClassMethods
      def log_in_as(role)
        attributes = case role
          when :student then {:admin? => false}
          when :admin then {:admin? => true}
          else raise "Unknown role: #{role}"
        end

        let(:current_user) { double(attributes) }

        before do
          controller.stub :current_user => current_user
        end
      end
    end

    module InstanceMethods
      def deny_access
        flash[:error].should be_present
        redirect_to root_path
      end
    end

    def self.included(example_group)
      example_group.extend ClassMethods
      example_group.send :include, InstanceMethods
    end
  end
end
