require File.dirname(__FILE__) + '/test_helper'

# no need to test on both adapters, so this one extends Test::Unit::TestCase
class CarbonFootprintTest < Test::Unit::TestCase
  def each_file_line
    @@files ||= Dir.glob "#{File.dirname(__FILE__) + '/..'}/**/*.{rb,rake}"

    @@files.each do |file|
      File.open(file, 'r').each_with_index do |line, number|
        number = number.next
        line   = line.chomp
        file   = file.sub './test/../', ''

        yield file, line, number if block_given?
      end
    end
  end

  def test_code_carbon_footprint
    each_file_line do |file, line, number|
      here = 'at `' + "#{file}:#{number}" + "'"

      assert_no_match /\t/, line,   "tab found #{here}"
      assert_no_match /\s+$/, line, "trailing whitespace #{here}"
      assert line.length < 78,      "line too long #{here}"
    end
  end
end