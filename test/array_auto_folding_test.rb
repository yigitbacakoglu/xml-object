require File.dirname(__FILE__) + '/test_helper'

class ArrayAutoFoldingTest < XMLObject::TestCase
  def test_array_auto_folding
    herd = XMLObject.new('<herd><sheep></sheep><sheep></sheep></herd>')
    assert_instance_of Array, herd.sheep
  end

  def test_behavior_of_auto_folded_array
    chart = XMLObject.new '<chart><axis>y</axis><axis>x</axis></chart>'

    assert_equal 'y', chart.axis[0]
    assert_equal 'y', chart.axis.first

    assert_equal 'x', chart.axis[1]
    assert_equal 'x', chart.axis.last

    assert_equal chart.axis, chart.axiss # 's' plural (naïve)
    assert_equal chart.axis, chart.axes if defined?(ActiveSupport::Inflector)
  end
end