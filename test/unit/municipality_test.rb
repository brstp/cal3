require 'test_helper'

class MunicipalityTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Municipality.new.valid?
  end
end
