require 'test_helper'

class ConstructorTest < XMLObject::TestCase
  def test_construction_from_strings
    assert_equal 'bar', XMLObject.new('<foo>bar</foo>')
  end

  def test_construction_from_something_that_responds_to_to_s
    duck = Class.new.new
    duck.class.instance_eval { undef_method :read } if duck.respond_to? :read

    def duck.to_s
      '<foo>bar</foo>'
    end

    assert_equal 'bar', XMLObject.new(duck)
  end

  def test_construction_from_something_that_responds_to_read
    duck = Class.new.new
    duck.class.instance_eval { undef_method :to_s } if duck.respond_to? :to_s

    def duck.read
      '<foo>bar</foo>'
    end

    assert_equal 'bar', XMLObject.new(duck)
  end

  def test_raise_exception_from_duck_that_responds_to_neither_to_s_or_read
    duck = Class.new.new
    duck.class.instance_eval { undef_method :read } if duck.respond_to? :read
    duck.class.instance_eval { undef_method :to_s } if duck.respond_to? :to_s

    assert_raise(RuntimeError) { XMLObject.new(duck) }
  end
end