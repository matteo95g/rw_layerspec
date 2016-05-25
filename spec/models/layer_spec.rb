require 'rails_helper'

RSpec.describe Layer, type: :model do
  let!(:layers) {
    layers = []
    layers << Layer.create(name: 'Layer data')
    layers << Layer.create(name: 'Layer data two')
    layers << Layer.create(name: 'Layer data one')
    layers
  }

  let!(:layer_first)  { layers[0] }
  let!(:layer_second) { layers[1] }
  let!(:layer_third)  { layers[2] }

  it 'Is valid' do
    expect(layer_first).to            be_valid
    expect(layer_first.slug).to       eq('layer-data')
    expect(layer_first.updated_at).to be_present
    expect(layer_first.created_at).to be_present
  end

  it 'Do not allow to create layer without name' do
    layer_reject = Layer.new(name: '')

    layer_reject.valid?
    expect {layer_reject.save!}.to raise_error(Mongoid::Errors::Validations)
  end

  it 'Do not allow to create layer with name douplications' do
    expect(layer_first).to be_valid
    layer_reject = Layer.new(name: 'Layer data')

    layer_reject.valid?
    expect {layer_reject.save!}.to raise_error(Mongoid::Errors::Validations)
  end
end
