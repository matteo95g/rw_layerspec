require 'acceptance_helper'

module V1
  describe 'Layers', type: :request do
    context 'Create, update and delete layers' do
      let!(:data) {{"marks": {
                    "type": "rect",
                    "from": {
                      "data": "table"
                  }}}}

      let!(:params)        {{"layer": { "name": "Second test layer", "data": data, "published": true, "status": 1 }}}
      let!(:params_faild)  {{"layer": { "name": "Layer second one", "data": data }}}
      let!(:update_params) {{"layer": { "name": "First test layer update", "slug": "test-layer-slug", "data": data }}}

      let!(:layer) {
        Layer.create!(name: 'Layer second one', published: true, status: 1, app_type: 1)
      }

      let!(:default_layer) {
        Layer.create!(name: 'Layer first one', published: true)
      }

      let!(:layer_id)   { layer.id   }
      let!(:layer_slug) { layer.slug }

      context 'List filters' do
        let!(:disabled_layer) {
          Layer.create!(name: 'Layer second second', slug: 'layer-second-second', status: 3, published: false)
        }

        let!(:enabled_layer) {
          Layer.create!(name: 'Layer one', status: 1, published: true, app_type: 2)
        }

        let!(:unpublished_layer) {
          Layer.create!(name: 'Layer one unpublished', status: 1, published: false)
        }

        it 'Show list of all layers' do
          get '/layers?status=all'

          expect(status).to eq(200)
          expect(json.size).to eq(5)
        end

        it 'Show list of layers with pending status' do
          get '/layers?status=pending'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers with active status' do
          get '/layers?status=active'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show list of layers with disabled status' do
          get '/layers?status=disabled'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers with published status true' do
          get '/layers?published=true'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
          expect(json[0]['published']).to eq(true)
        end

        it 'Show list of layers with published status false' do
          get '/layers?published=false'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
          expect(json[0]['published']).to eq(false)
        end

        it 'Show list of layers for app GFW' do
          get '/layers?app=GFW'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers for app WRW' do
          get '/layers?app=wrw'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers' do
          get '/layers'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end
      end

      it 'Show layer by slug' do
        get "/layers/#{layer_slug}"

        expect(status).to eq(200)
        expect(json['slug']).to           eq('layer-second-one')
        expect(json['meta']['status']).to eq('saved')
      end

      it 'Show layer by id' do
        get "/layers/#{layer_id}"

        expect(status).to eq(200)
      end

      it 'Allows to create second layer' do
        post '/layers', params: params

        expect(status).to eq(201)
        expect(json['id']).to          be_present
        expect(json['slug']).to        eq('second-test-layer')
        expect(json['custom_data']).to eq({"marks"=>{"type"=>"rect", "from"=>{"data"=>"table"}}})
      end

      it 'Name and slug validation' do
        post '/layers', params: params_faild

        expect(status).to eq(422)
        expect(json['success']).to         eq(false)
        expect(json['message']['name']).to eq(['is already taken'])
        expect(json['message']['slug']).to eq(['is already taken'])
      end

      it 'Allows to update layer' do
        put "/layers/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to   eq(layer_id)
        expect(json['name']).to eq('First test layer update')
        expect(json['slug']).to eq('test-layer-slug')
      end

      it 'Allows to delete layer by id' do
        delete "/layers/#{layer_id}"

        expect(status).to eq(200)
        expect(json['message']).to eq('Layer deleted')
        expect(Layer.where(id: layer_id)).to be_empty
      end

      it 'Allows to delete layer by slug' do
        delete "/layers/#{layer_slug}"

        expect(status).to eq(200)
        expect(json['message']).to eq('Layer deleted')
        expect(Layer.where(slug: layer_slug)).to be_empty
      end
    end
  end
end
