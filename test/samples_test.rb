require File.dirname(__FILE__) + '/test_helper'

class SamplesTest < XMLObject::TestCase
  def test_behaviour_of_sample_atom_dot_xml
    feed = XMLObject.new %'<?xml version="1.0" encoding="utf-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom">

       <title>Example Feed</title>
       <subtitle>A subtitle.</subtitle>
       <link href="http://example.org/feed/" rel="self"/>
       <link href="http://example.org/"/>
       <updated>2003-12-13T18:30:02Z</updated>
       <author>
         <name>John Doe</name>
         <email>johndoe@example.com</email>
       </author>
       <id>urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6</id>

       <entry>
         <title>Atom-Powered Robots Run Amok</title>
         <link href="http://example.org/2003/12/13/atom03"/>
         <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
         <updated>2003-12-13T18:30:02Z</updated>
         <summary>Some text.</summary>
       </entry>
      </feed>'

    assert_equal '', feed

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://www.w3.org/2005/Atom', feed.xmlns
    end

    assert_equal 'Example Feed', feed.title
    assert_equal 'A subtitle.',  feed.subtitle

    assert_instance_of Array, feed.link
    assert_equal       feed.links, feed.link

    assert_equal 'http://example.org/feed/', feed.link.first.href
    assert_equal 'self',                     feed.link.first.rel
    assert_equal 'http://example.org/',      feed.link.last.href

    assert_equal '2003-12-13T18:30:02Z', feed.updated

    assert_equal '',                    feed.author
    assert_equal 'John Doe',            feed.author.name
    assert_equal 'johndoe@example.com', feed.author.email

    assert_equal 'urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6', feed['id']

    assert_equal '', feed.entry
    assert_equal 'Atom-Powered Robots Run Amok', feed.entry.title
    assert_equal '2003-12-13T18:30:02Z',         feed.entry.updated
    assert_equal 'Some text.',                   feed.entry.summary
    assert_equal \
      'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a', feed.entry['id']
  end

  def test_behaviour_of_sample_function_dot_xml
    function = XMLObject.new \
      %'<function name="Hello">
          <description>Greets the indicated person.</description>
          <input>
            <param name="name" required="true">
              <description>The name of the greeted person.</description>
            </param>
          </input>
          <output>
            <param name="greeting" required="true">
              <description>The constructed greeting.</description>
            </param>
          </output>
        </function>'

    assert_equal '', function
    assert_equal 'Hello', function.name
    assert_equal 'Greets the indicated person.', function.description

    assert_equal '', function.input
    assert_equal '', function.input.param
    assert_equal 'name', function.input.param.name
    assert_equal 'true', function.input.param.required
    assert       function.input.param.required?
    assert_equal 'The name of the greeted person.',
                 function.input.param.description

    assert_equal '', function.output
    assert_equal '', function.output
    assert_equal 'greeting', function.output.param.name
    assert_equal 'true', function.output.param.required
    assert       function.output.param.required?
    assert_equal 'The constructed greeting.',
                 function.output.param.description
  end

  def test_behaviour_of_sample_persons_dot_xml
    persons = XMLObject.new %'<?xml version="1.0" ?>
                              <persons>
                                <person username="JS1">
                                  <name>John</name>
                                  <family-name>Smith</family-name>
                                </person>
                                <person username="MI1">
                                  <name>Morka</name>
                                  <family-name>Ismincius</family-name>
                                </person>
                              </persons>'

    assert_equal [ '', '' ],      persons
    assert_equal persons.person,  persons
    assert_equal persons.persons, persons

    if defined? ActiveSupport::Inflector
      assert_equal persons.people, persons
    end

    assert_equal '', persons[0]
    assert_equal '', persons[-1]

    assert_equal 'JS1',   persons.first.username
    assert_equal 'John',  persons.first.name
    assert_equal 'Smith', persons.first['family-name']

    assert_equal 'MI1',       persons.last.username
    assert_equal 'Morka',     persons.last.name
    assert_equal 'Ismincius', persons.last[:'family-name']
  end

  def test_behaviour_of_sample_playlist_dot_xml
    playlist = XMLObject.new %'<?xml version="1.0" encoding="UTF-8"?>
      <playlist version="1" xmlns="http://xspf.org/ns/0/">
        <trackList>
          <track>
            <title>Internal Example</title>
            <location>file:///C:/music/foo.mp3</location>
          </track>
          <track>
            <title>External Example</title>
            <location>http://www.example.com/music/bar.ogg</location>
          </track>
        </trackList>
      </playlist>'

    assert_equal '',  playlist
    assert_equal '1', playlist.version

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://xspf.org/ns/0/', playlist.xmlns
    end

    # can't use 'assert_instance_of' here, not yet anyway.
    assert_equal Array, playlist.trackList.class

    assert_instance_of Array, playlist.trackList.track
    assert_instance_of Array, playlist.trackList.tracks

    assert_equal playlist.trackList.track,  playlist.trackList
    assert_equal playlist.trackList.tracks, playlist.trackList

    assert_equal playlist.trackList, playlist.trackList.track

    assert_equal 'Internal Example',         playlist.trackList.first.title
    assert_equal 'file:///C:/music/foo.mp3',
                 playlist.trackList.first.location

    assert_equal 'External Example', playlist.trackList.last.title
    assert_equal 'http://www.example.com/music/bar.ogg',
                 playlist.trackList.last.location
  end

  def test_behaviour_of_sample_recipe_dot_xml
    recipe = XMLObject.new \
      %'<recipe name="bread" prep_time="5 mins" cook_time="3 hours">
          <title>Basic bread</title>
          <ingredient amount="8" unit="dL">Flour</ingredient>
          <ingredient amount="10" unit="grams">Yeast</ingredient>
          <ingredient amount="4" unit="dL" state="warm">Water</ingredient>
          <ingredient amount="1" unit="teaspoon">Salt</ingredient>
          <instructions>
            <step>Mix all ingredients together.</step>
            <step>Knead thoroughly.</step>
            <step>Cover with a cloth, and leave for one hour.</step>
            <step>Knead again.</step>
            <step>Place in a bread baking tin.</step>
            <step>Cover with a cloth, and leave for one hour.</step>
            <step>Bake in the oven at 180(degrees)C for 30 minutes.</step>
          </instructions>
        </recipe>'

    assert_equal '',            recipe
    assert_equal 'bread',       recipe.name
    assert_equal '5 mins',      recipe.prep_time
    assert_equal '3 hours',     recipe.cook_time
    assert_equal 'Basic bread', recipe.title

    assert_instance_of Array, recipe.ingredient
    assert_equal recipe.ingredient, recipe.ingredients
    assert_equal %w[ Flour Yeast Water Salt ], recipe.ingredients
    assert_equal %w[ 8 10 4 1 ], recipe.ingredients.map { |i| i.amount }
    assert_equal 'warm', recipe.ingredients[2].state
    assert_equal %w[ dL grams dL teaspoon ],
                 recipe.ingredients.map { |i| i.unit }

    # can't use instance_of? here
    assert_equal Array, recipe.instructions.class

    assert_instance_of Array, recipe.instructions.step
    assert_instance_of Array, recipe.instructions.steps

    assert_equal recipe.instructions.steps, recipe.instructions
    assert_equal recipe.instructions.steps, recipe.instructions.step

    assert_equal 'Mix, Knead, Cover, Knead, Place, Cover, Bake',
                 recipe.instructions.map { |s| s.split(' ')[0] }.join(', ')
  end

  def test_behaviour_of_sample_voice_dot_xml
    voice = XMLObject.new \
      %'<vxml version="2.0" xmlns="http://www.w3.org/2001/vxml">
          <form>
            <block>
              <prompt>
                Hello world!
              </prompt>
            </block>
          </form>
        </vxml>'

    assert_equal '',    voice
    assert_equal '2.0', voice.version

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://www.w3.org/2001/vxml', voice.xmlns
    end

    assert_equal '', voice.form
    assert_equal '', voice.form.block
    assert_equal 'Hello world!', voice.form.block.prompt.strip
  end
end