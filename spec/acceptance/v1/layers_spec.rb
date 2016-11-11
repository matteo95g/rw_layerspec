require 'acceptance_helper'

module V1
  describe 'Layers', type: :request do
    context 'Create, update and delete layers' do
      let!(:data) {{"marks": {
                    "type": "rect",
                    "from": {
                      "data": "table"
                  }}}}

      let!(:params) {{"layer": {
                      "application": "GFW",
                      "name": "second-test-layer",
                      "provider": "Cartodb",
                      "datasetId": "c867138c-eccf-4e57-8aa2-b62b87800ddf",
                      "description": "Lorem ipsum dolor...",
                      "iso": [
                        "BRA",
                        "AUS",
                        "ESP"
                      ],
                      "layerConfig": {
                        "display": true,
                        "max_date": "2016-02-14",
                        "min_date": "2012-01-12",
                        "fit_to_geom": true
                      },
                      "legend_config": {
                        "marks": {
                          "type": "rect",
                          "from": {
                            "data": "table"
                          }
                        }
                      },
                      "applicationConfig": {
                        "config one": {
                          "type": "lorem",
                          "from": {
                            "data": "table"
                          }
                        }
                      },
                      "status": 1,
                      "published": true,
                      "default": true
                    }}}

      let!(:params_provider) {{"layer": {
                               "application": "test",
                               "name": "third-test-layer",
                               "provider": "Test"
                              }}}

      let!(:params_faild)  {{"layer": { "name": "Layer second one", "application_config": data }}}
      let!(:update_params) {{"layer": { "name": "First test layer update", "slug": "test-layer-slug", "application_config": data }}}

      let!(:layer) {
        Layer.create!(name: 'Layer second one', published: true, status: 1, application: 'gfw', dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg')
      }

      let!(:default_layer) {
        Layer.create!(name: 'Layer first one', published: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg', application: 'WRW')
      }

      let!(:layer_id)   { layer.id   }
      let!(:layer_slug) { layer.slug }

      context 'List filters' do
        let!(:disabled_layer) {
          Layer.create!(name: 'Layer second second', slug: 'layer-second-second', status: 3, published: false)
        }

        let!(:enabled_layer) {
          Layer.create!(name: 'Layer one', status: 1, published: true, application: 'Wrw')
        }

        let!(:unpublished_layer) {
          Layer.create!(name: 'Layer one unpublished', status: 1, published: false)
        }

        it 'Show list of all layers' do
          get '/layer?status=all'

          expect(status).to eq(200)
          expect(json.size).to eq(5)
        end

        it 'Show list of layers with pending status' do
          get '/layer?status=pending'

          expect(status).to eq(200)
          expect(json.size).to eq(0)
        end

        it 'Show list of layers with active status' do
          get '/layer?status=active'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of layers with disabled status' do
          get '/layer?status=disabled'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers with published status true' do
          get '/layer?published=true'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of layers with published status false' do
          get '/layer?published=false'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show list of layers for app GFW' do
          get '/layer?app=GF'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers for app WRW' do
          get '/layer?app=wrw'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show blank list of layers for not existing app' do
          get '/layer?app=notexisting'

          expect(status).to eq(200)
          expect(json.size).to eq(0)
        end

        it 'Show list of layers' do
          get '/layer'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Filter by existing dataset' do
          get '/layer?dataset=c867138c-eccf-4e57-8aa2-b62b87800ddg'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Filter by not existing dataset' do
          get '/layer?dataset=c867138c-eccf-4e57-8aa2-b62b87800ddf'

          expect(status).to eq(200)
          expect(json.size).to eq(0)
        end

        it 'Filter by existing dataset by url' do
          get '/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Filter by existing dataset by url and app' do
          get '/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer?app=gfw'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Filter by not existing dataset by url' do
          get '/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddf/layer'

          expect(status).to eq(200)
          expect(json.size).to eq(0)
        end
      end

      it 'Show layer by slug' do
        get "/layer/#{layer_slug}"

        expect(status).to eq(200)
        expect(json['attributes']['slug']).to     eq('layer-second-one')
        expect(json_main['meta']['status']).to    eq('saved')
        expect(json_main['meta']['published']).to eq(true)
      end

      it 'Show layer by id' do
        get "/layer/#{layer_id}"

        expect(status).to eq(200)
      end

      it 'Allows to create second layer' do
        post '/layer', params: params

        expect(status).to eq(201)
        expect(json['id']).to                          be_present
        expect(json['attributes']['slug']).to          eq('second-test-layer')
        expect(json['attributes']['provider']).to      eq('cartodb')
        expect(json['attributes']['application']).to   eq('gfw')
        expect(json['attributes']['legendConfig']).to eq({"marks"=>{"type"=>"rect", "from"=>{"data"=>"table"}}})
      end

      it 'Allows to create layer with not valid provider' do
        post '/layer', params: params_provider

        expect(status).to eq(201)
        expect(json['id']).to                        be_present
        expect(json['attributes']['slug']).to        eq('third-test-layer')
        expect(json['attributes']['provider']).to    eq('not valid provider')
        expect(json['attributes']['application']).to eq('not valid application')
      end

      it 'Name and slug validation' do
        post '/layer', params: params_faild

        expect(status).to eq(422)
        expect(json_main['success']).to         eq(false)
        expect(json_main['message']['name']).to eq(['is already taken'])
        expect(json_main['message']['slug']).to eq(['is already taken'])
      end

      it 'Allows to update layer via put' do
        put "/layer/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to                 eq(layer_id)
        expect(json['attributes']['name']).to eq('First test layer update')
        expect(json['attributes']['slug']).to eq('test-layer-slug')
      end

      it 'Allows to update layer via patch' do
        patch "/layer/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to                 eq(layer_id)
        expect(json['attributes']['name']).to eq('First test layer update')
        expect(json['attributes']['slug']).to eq('test-layer-slug')
      end

      it 'Allows to delete layer by id' do
        delete "/layer/#{layer_id}"

        expect(status).to eq(200)
        expect(json_main['message']).to      eq('Layer deleted')
        expect(Layer.where(id: layer_id)).to be_empty
      end

      it 'Allows to delete layer by slug' do
        delete "/layer/#{layer_slug}"

        expect(status).to eq(200)
        expect(json_main['message']).to          eq('Layer deleted')
        expect(Layer.where(slug: layer_slug)).to be_empty
      end
    end
  end
end
