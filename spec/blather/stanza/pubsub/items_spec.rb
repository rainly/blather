require File.join(File.dirname(__FILE__), *%w[.. .. .. spec_helper])
require File.join(File.dirname(__FILE__), *%w[.. .. .. fixtures pubsub])

describe 'Blather::Stanza::PubSub::Items' do
  it 'registers itself' do
    XMPPNode.class_from_registration(:pubsub_items, 'http://jabber.org/protocol/pubsub').must_equal Stanza::PubSub::Items
  end

  it 'ensures an items node is present on create' do
    items = Stanza::PubSub::Items.new
    items.pubsub.children.detect { |n| n.element_name == 'items' }.wont_be_nil
  end

  it 'ensures an items node exists when calling #items' do
    items = Stanza::PubSub::Items.new
    items.pubsub.remove_child :items
    items.pubsub.children.detect { |n| n.element_name == 'items' }.must_be_nil

    items.items.wont_be_nil
    items.pubsub.children.detect { |n| n.element_name == 'items' }.wont_be_nil    
  end

  it 'defaults to a get node' do
    aff = Stanza::PubSub::Items.new
    aff.type.must_equal :get
  end

  it 'can create an items request node to request all items' do
    host = 'pubsub.jabber.local'
    node = 'princely_musings'

    items = Stanza::PubSub::Items.request host, node
    items.find("//pubsub/items[@node=\"#{node}\"]").size.must_equal 1
    items.to.must_equal JID.new(host)
  end

  it 'can create an items request node to request some items' do
    host = 'pubsub.jabber.local'
    node = 'princely_musings'
    items = %w[item1 item2]

    items_xpath = items.map { |i| "@id=\"#{i}\"" } * ' or '

    items = Stanza::PubSub::Items.request host, node, items
    items.find("//pubsub/items[@node=\"#{node}\"]/item[#{items_xpath}]").size.must_equal 2
    items.to.must_equal JID.new(host)
  end

  it 'can create an items request node to request "max_number" of items' do
    host = 'pubsub.jabber.local'
    node = 'princely_musings'
    max = 3

    items = Stanza::PubSub::Items.request host, node, nil, max
    items.find("//pubsub/items[@node=\"#{node}\" and @max_items=\"#{max}\"]").size.must_equal 1
    items.to.must_equal JID.new(host)
  end
  
end
