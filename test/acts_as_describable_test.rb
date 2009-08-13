require File.dirname(__FILE__) + '/test_helper'

class ActsAsDescribableTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  ActiveSupport::TestCase.load_schema
  class Site < ActiveRecord::Base
  	acts_as_describable
  end

  test 'schema_has_loaded_correctly' do
    assert false
  end

end

