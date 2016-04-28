require 'spec_helper'
require 'vortex'

describe Vortex do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end

describe ApplicationTemplate do
  subject(:template) { ApplicationTemplate.new(greeting: greeting) }

  let(:greeting) { 'hi there' }

  let(:view) { template.show }

  it 'should greet you' do
    expect(view).to be_a(Dedalus::Elements::Heading)
    expect(view.text).to eq(greeting)
  end
end
