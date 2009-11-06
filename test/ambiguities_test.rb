require File.dirname(__FILE__) + '/test_helper'

class AmbiguitiesTest < XMLObject::TestCase
  def test_ambiguity_of_element_and_attribute_name
    toy = XMLObject.new %'<toy name="name attribute value">
                            <name>name as element text</name>
                          </toy>'

    assert_equal 'name as element text', toy.name
    assert_equal 'name as element text', toy['name']

    assert_equal 'name as element text', toy[:elem => 'name']
    assert_equal 'name attribute value', toy[:attr => 'name']
  end

  def test_ambiguity_of_s_pluralized_array_and_element_name
    kennel = XMLObject.new %| <kennel>
                                <dogs>Bruce, Muni, Charlie</dogs>
                                <dog>Rex</dog>
                                <dog>Roxy</dog>
                              </kennel> |

    assert_equal 'Bruce, Muni, Charlie', kennel['dogs']
    assert_equal 'Bruce, Muni, Charlie', kennel[:elem => 'dogs']
    assert_equal 'Bruce, Muni, Charlie', kennel.dogs

    # We still maintain access to the array by its original name:
    assert_equal 'Rex & Roxy', kennel.dog.join(' & ')
    assert_equal 'Rex & Roxy', kennel['dog'].join(' & ')
    assert_equal 'Rex & Roxy', kennel[:elem => 'dog'].join(' & ')
  end

  def test_ambiguity_of_inflector_pluralized_array_and_element_name
    aquarium = XMLObject.new %| <aquarium>
                                  <octopi>Mean, Ugly, Scary</octopi>
                                  <octopus>Tasty</octopus>
                                  <octopus>Chewy</octopus>
                                </aquarium> |

    assert_equal 'Mean, Ugly, Scary', aquarium['octopi']
    assert_equal 'Mean, Ugly, Scary', aquarium[:elem => 'octopi']
    assert_equal 'Mean, Ugly, Scary', aquarium.octopi

    # We still maintain access to the array by its original name:
    assert_equal 'Tasty & Chewy', aquarium.octopus.join(' & ')
    assert_equal 'Tasty & Chewy', aquarium['octopus'].join(' & ')
    assert_equal 'Tasty & Chewy', aquarium[:elem => 'octopus'].join(' & ')
  end

  def test_ambiguity_of_s_pluralized_array_and_attribute_name
    book = XMLObject.new %|
      <book chapters="2">
        <chapter>Introduction</chapter>
        <chapter>Some stuff</chapter>
        <chapter>More stuff</chapter>
      </book> |

    assert_equal '2', book.chapters
    assert_equal '2', book['chapters']
    assert_equal '2', book[:attr => 'chapters']

    assert_instance_of Array, book.chapter
    assert_instance_of Array, book['chapter']
    assert_instance_of Array, book[:elem => 'chapter']
  end

  def test_ambiguity_of_inflector_pluralized_array_and_attribute_name
    dog = XMLObject.new %|
      <dog feet="4">
        <foot>A</foot>
        <foot>B</foot>
        <foot>C</foot>
        <foot>D</foot>
      </dog> |

    assert_equal '4', dog.feet
    assert_equal '4', dog['feet']
    assert_equal '4', dog[:attr => 'feet']

    assert_instance_of Array, dog.foot
    assert_instance_of Array, dog['foot']
    assert_instance_of Array, dog[:elem => 'foot']
  end

  def test_ambiguity_of_pluralized_array_and_attribute_and_element_name
    file = XMLObject.new %|
      <file bits="bits attribute">
        <bits>bits element</bits>
        <bit>0</bit>
        <bit>1</bit>
      </file> |

    # prioritize the element over all others
    assert_equal 'bits element', file.bits
    assert_equal 'bits element', file['bits']

    # allow respective unambiguous access
    assert_equal 'bits element',   file[:elem => 'bits']
    assert_equal 'bits attribute', file[:attr => 'bits']

    # to the Array as well
    assert_instance_of Array, file.bit
    assert_instance_of Array, file['bit']
    assert_instance_of Array, file[:elem => 'bit']
  end

  def test_ambiguity_of_attribute_and_method_name
    string = XMLObject.new '<string upcase="not the method">hello</string>'
    assert_equal 'hello', string
    assert_equal 'HELLO', string.upcase

    assert_equal 'not the method', string['upcase']
    assert_equal 'not the method', string[:attr => 'upcase']
  end

  def test_ambiguity_of_element_and_method_name
    string = XMLObject.new '<string><upcase>Hi There</upcase></string>'
    assert_equal '', string
    assert_equal '', string.upcase

    assert_equal 'Hi There', string['upcase']
    assert_equal 'Hi There', string[:elem => 'upcase']
  end
end