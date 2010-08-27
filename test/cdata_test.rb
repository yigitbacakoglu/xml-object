require 'test_helper'

class CDATATest < XMLObject::TestCase
  def test_multiple_CDATA_blocks
    lots_of_data = XMLObject.new %| <lots_of_data>
                                      <![CDATA[Lots of CDA]]>
                                      <![CDATA[TA! here, man]]>
                                    </lots_of_data> |

    assert_equal 'Lots of CDATA! here, man', lots_of_data
  end

  def test_CDATA_without_text
    no_text = XMLObject.new '<no_text><![CDATA[Not Text, CDATA]]></no_text>'
    assert_equal 'Not Text, CDATA', no_text
  end

  def test_both_CDATA_and_text
    two_face = XMLObject.new '<two_face>Text<![CDATA[Not Text]]></two_face>'
    assert_equal 'Text', two_face
  end

  def test_whitespace_CDATA_only
    not_much = XMLObject.new "<not_much><![CDATA[\t \n]]></not_much>"
    assert_equal "\t \n", not_much
  end

  def test_whitespace_and_non_whitespace_CDATA
    sloppy = XMLObject.new "<x><![CDATA[\t a \n]]></x>"
    assert_equal "\t a \n", sloppy
  end
end