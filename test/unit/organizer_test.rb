require 'test_helper'

class OrganizerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Organizer.new.valid?
  end
end
