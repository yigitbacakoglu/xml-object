require File.dirname(__FILE__) + '/test_helper'

class WhitespaceTest < XMLObject::TestCase

  def test_whitespace_stripping_of_attribute_values
    dude = XMLObject.new %'<dude name=" \n bob \t" />'
    assert_equal 'bob', dude.name
  end

  def test_whitespace_text_only
    not_much = XMLObject.new "<not_much>\t \n </not_much>"
    assert_equal '', not_much
  end

  def test_whitespace_and_non_whitespace_text
    sloppy = XMLObject.new "<sloppy>\t a \n</sloppy>"
    assert_equal "\t a \n", sloppy
  end
end