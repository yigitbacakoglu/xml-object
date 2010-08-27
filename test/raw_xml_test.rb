require 'test_helper'

class RawXML < XMLObject::TestCase
  def test_raw_xml_method
    expected = case
      when XMLObject.adapter == XMLObject::Adapters::REXML
        then REXML::Element

      when XMLObject.adapter == XMLObject::Adapters::LibXML
        then LibXML::XML::Node

      else nil
    end

    assert_kind_of expected, XMLObject.new('<x/>').raw_xml
  end
end