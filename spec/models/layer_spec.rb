require 'rails_helper'

RSpec.describe Layer, type: :model do
  let!(:layers) {
    layers = []
    layers << Layer.create(name: 'Layer data',     application: 'gfw',  default: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800dda')
    layers << Layer.create(name: 'Layer data two', application: 'wrw',  default: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddb')
    layers << Layer.create(name: 'Layer data one', application: 'prep', default: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddc')
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
    expect { layer_reject.save! }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'Do not allow to create layer with name douplications' do
    expect(layer_first).to be_valid
    layer_reject = Layer.new(name: 'Layer data')

    layer_reject.valid?
    expect { layer_reject.save! }.to raise_error(Mongoid::Errors::Validations)
  end

  it 'Allow to create not default layer for unique dataset and application' do
    expect(layer_first).to be_valid
    layer_second = Layer.create(name: 'Layer data new', application: 'gfw', default: false, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800dda')
    expect(layer_second).to be_valid
  end

  it 'Do not allow to create default layer for unique dataset and application' do
    expect(layer_first).to be_valid
    layer_reject = Layer.new(name: 'Layer data new', application: 'gfw', default: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800dda')

    layer_reject.valid?
    expect { layer_reject.save! }.to raise_error(Mongoid::Errors::Validations)
  end
end
