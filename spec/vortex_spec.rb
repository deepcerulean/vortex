require 'spec_helper'
require 'vortex'
require 'metacosm/support/spec_harness'

describe Vortex do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end

describe ApplicationTemplate do
  subject(:template) { ApplicationTemplate.new(greeting: greeting) }

  let(:greeting) { 'hi there' }

  let(:view) { template.show }

  let(:welcome_message) do
    view.detect do |element|
      element.is_a?(Dedalus::Elements::Heading)
    end
  end

  it 'should greet you' do
    expect(welcome_message.text).to eq(greeting)
  end
end

# TODO test commands/events...
