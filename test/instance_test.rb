require 'test_helper'

class InstanceTest < XMLObject::TestCase
  def test_object_without_attributes_text_or_cdata
    rock = XMLObject.new '<rock><color> </color> <mass /></rock>'
    assert_equal '', rock

    assert_raise(NameError) { rock.not_an_attribute_or_element    }
    assert_raise(NameError) { rock['not_an_attribute_or_element'] }
    assert_raise(NameError) { rock[:elem => 'not_an_element']     }
    assert_raise(NameError) { rock[:attr => 'not_an_attribute']   }
  end

  def test_object_with_child_element
    car = XMLObject.new '<car><wheels>4</wheels></car>'

    assert_equal '4', car.wheels
    assert_equal '4', car['wheels']
    assert_equal '4', car[:wheels]
    assert_equal '4', car[:elem  => 'wheels']
    assert_equal '4', car[:elem  => :wheels]
    assert_equal '4', car['elem' => 'wheels']
    assert_equal '4', car['elem' => :wheels]
  end

  def test_object_with_attribute
    student = XMLObject.new '<student name="Carla" />'

    assert_equal 'Carla', student.name
    assert_equal 'Carla', student['name']
    assert_equal 'Carla', student[:name]
    assert_equal 'Carla', student[:attr  => 'name']
    assert_equal 'Carla', student[:attr  => :name]
    assert_equal 'Carla', student['attr' => 'name']
    assert_equal 'Carla', student['attr' => :name]
  end
end