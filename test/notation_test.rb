require File.dirname(__FILE__) + '/test_helper'

module Notation
  class Dot < XMLObject::TestCase
    def test_elements_named_like_invalid_ruby_method_names
      x = XMLObject.new '<x><invalid-method>XML!</invalid-method></x>'
      assert_equal 'XML!', x['invalid-method']
    end

    def test_attributes_named_like_invalid_ruby_method_names
      x = XMLObject.new '<x attr-with-dashes="XML too!" />'
      assert_equal 'XML too!', x['attr-with-dashes']
    end
  end

  class Predicate < XMLObject::TestCase
    def test_boolean_like_attributes
      house = XMLObject.new %| <house tall="Yes"   short="no"
                                      cubeish="y"  roundish="N"
                                      heavy="T"    light="f"
                                      house="tRUE" ball="fAlSE"
                                      hypercube="What?" /> |

      assert house.tall?
      assert house.cubeish?
      assert house.heavy?
      assert house.house?

      assert !house.short?
      assert !house.roundish?
      assert !house.light?
      assert !house.ball?

      assert_raise(NameError) { house.hypercube? }
    end

    def test_boolean_like_elements
      house = XMLObject.new %| <house>
                                 <tall>yEs</tall>     <short>nO</short>
                                 <cubeish>Y</cubeish> <roundish>n</roundish>
                                 <heavy>t</heavy>     <light>F</light>
                                 <house>tRue</house>  <ball>FalsE</ball>

                                 <hypercube>the hell?</hypercube>
                               </house> |

      assert house.tall?
      assert house.cubeish?
      assert house.heavy?
      assert house.house?

      assert !house.short?
      assert !house.roundish?
      assert !house.light?
      assert !house.ball?

      assert_raise(NameError) { house.hypercube? }
    end
  end

  class HashIndex < XMLObject::TestCase
    def test_invalid_key_when_using_hash_on_array_notation
      assert_raise(NameError) do
        foo = XMLObject.new '<foo><bar /></foo>'
        foo[:not_a_valid_key => 'bar']
      end
    end
  end
end