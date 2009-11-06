require File.dirname(__FILE__) + '/test_helper'

class RegressionsTest < XMLObject::TestCase
  def test_behaviour_of_bug_sample_rating_dot_xml
    rating = XMLObject.new %'<rating>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                             </rating>'

    # can't use instance_of? here
    assert_equal Array, rating.class

    assert_equal 3, rating.size
    assert_equal 3, rating.category.size
    assert_equal 3, rating.category.first.size
  end
end