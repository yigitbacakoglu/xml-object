require File.dirname(__FILE__) + '/test_helper'

class CollectionProxyTest < XMLObject::TestCase
  def test_behaviour_of_collection_proxy
    two = XMLObject.new '<two><dude>Peter</dude><dude>Paul</dude></two>'

    assert_equal two.dudes, two
    assert_equal two.dudes[-1], two[-1]
    assert_equal two.dudes.first.downcase, two.first.downcase
    assert_equal two.dudes.map { |d| d.upcase }, two.map { |d| d.upcase }
  end

  def test_collection_proxy
    flock = XMLObject.new %| <flock>
                               <sheep number="0">?</sheep>
                               <sheep number="1">Dolly</sheep>
                             </flock> |

    # Empty elements with single array children act as proxies to the array
    assert_equal flock,       flock.sheep
    assert_equal flock.first, flock.sheep.first

    assert_equal '0', flock.first.number
    assert_equal '0', flock.sheep.first.number

    assert_equal 2, flock.size
    assert_equal 2, flock.sheep.size
  end

  def test_NOT_collection_proxy_due_to_text
    mob = XMLObject.new %| <mob>Some text about the mob
                             <sheep number="0">?</sheep>
                             <sheep number="1">Dolly</sheep>
                           </mob> |

    assert_instance_of String, mob
    assert_equal 'Some text about the mob', mob.strip

    assert_instance_of Array, mob.sheep
  end

  def test_NOT_collection_proxy_due_to_CDATA
    drove = XMLObject.new %| <drove><![CDATA[Sheep groups have many names]]>
                               <sheep number="0">?</sheep>
                               <sheep number="1">Dolly</sheep>
                             </drove> |

    assert_instance_of String, drove
    assert_equal 'Sheep groups have many names', drove

    assert_instance_of Array, drove.sheep
  end

  def test_NOT_collection_proxy_due_to_non_array_single_child
    trip = XMLObject.new '<trip><sheep number="1">Dolly</sheep></trip>'
    assert_not_equal trip, trip.sheep
  end
end