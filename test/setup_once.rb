require 'test/unit'

module Test::SetupOnce
  module ClassMethods
    def setup_once; end
    def teardown_once; end

    def suite
      returning super do |suite|
        suite.send(:instance_variable_set, :@_test_klazz, self)
        suite.instance_eval do
          def run(*args)
            @_test_klazz.setup_once
            super
            @_test_klazz.teardown_once
          end
        end
      end
    end
  end

  def self.included(test)
    test.extend(ClassMethods)
  end
end
