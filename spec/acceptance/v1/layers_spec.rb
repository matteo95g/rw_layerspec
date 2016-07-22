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
                      "category": "test category",
                      "subcategory": "sub category",
                      "iso": [
                        "BRA",
                        "AUS",
                        "ESP"
                      ],
                      "analyzable": true,
                      "group": "Jungle",
                      "global": true,
                      "info_window": false,
                      "max_zoom": 20,
                      "children": [
                        "first child",
                        "second child"
                      ],
                      "info": {
                        "title": "Second test",
                        "subtitle": "subtitle",
                        "legend_template": "my template string",
                        "info_window_template": "Tamplate infowindow",
                        "z_index": 1,
                        "color": "#000000",
                        "dataset-id": "c867138c-eccf-4e57-8aa2-b62b87800ddf",
                        "title_color": "#111111"
                      },
                      "display": {
                        "display": true,
                        "max_date": "2016-02-14",
                        "min_date": "2012-01-12",
                        "fit_to_geom": true
                      },
                      "custom_data": {
                        "marks": {
                          "type": "rect",
                          "from": {
                            "data": "table"
                          }
                        }
                      },
                      "status": "saved",
                      "published": true
                    }}}
      let!(:params_provider) {{"layer": {
                               "application": "test",
                               "name": "third-test-layer",
                               "provider": "Test"
                              }}}

      let!(:params_faild)  {{"layer": { "name": "Layer second one", "custom_data": data }}}
      let!(:update_params) {{"layer": { "name": "First test layer update", "slug": "test-layer-slug", "custom_data": data }}}

      let!(:layer) {
        Layer.create!(name: 'Layer second one', published: true, status: 1, application: 'gfw', children: ['first_child', 'second_child'])
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
          Layer.create!(name: 'Layer one', status: 1, published: true, application: 'Wrw')
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
          expect(json.size).to eq(0)
        end

        it 'Show list of layers with active status' do
          get '/layers?status=active'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end

        it 'Show list of layers with disabled status' do
          get '/layers?status=disabled'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show list of layers with published status true' do
          get '/layers?published=true'

          expect(status).to eq(200)
          expect(json.size).to                                  eq(3)
          expect(json[0]['attributes']['meta']['published']).to eq(true)
        end

        it 'Show list of layers with published status false' do
          get '/layers?published=false'

          expect(status).to eq(200)
          expect(json.size).to                                  eq(2)
          expect(json[0]['attributes']['meta']['published']).to eq(false)
        end

        it 'Show list of layers for app GFW' do
          get '/layers?app=GF'

          expect(status).to eq(200)
          expect(json.size).to eq(2)
        end

        it 'Show list of layers for app WRW' do
          get '/layers?app=wrw'

          expect(status).to eq(200)
          expect(json.size).to eq(1)
        end

        it 'Show blank list of layers for not existing app' do
          get '/layers?app=notexisting'

          expect(status).to eq(200)
          expect(json.size).to eq(0)
        end

        it 'Show list of layers' do
          get '/layers'

          expect(status).to eq(200)
          expect(json.size).to eq(3)
        end
      end

      it 'Show layer by slug' do
        get "/layers/#{layer_slug}"

        expect(status).to eq(200)
        expect(json['attributes']['slug']).to           eq('layer-second-one')
        expect(json['attributes']['meta']['status']).to eq('saved')
        expect(json['attributes']['children']).to       eq(['first_child', 'second_child'])
      end

      it 'Show layer by id' do
        get "/layers/#{layer_id}"

        expect(status).to eq(200)
      end

      it 'Allows to create second layer' do
        post '/layers', params: params

        expect(status).to eq(201)
        expect(json['id']).to                        be_present
        expect(json['attributes']['slug']).to        eq('second-test-layer')
        expect(json['attributes']['provider']).to    eq('cartodb')
        expect(json['attributes']['application']).to eq('gfw')
        expect(json['attributes']['custom-data']).to eq({"marks"=>{"type"=>"rect", "from"=>{"data"=>"table"}}})
      end

      it 'Allows to create layer with not valid provider' do
        post '/layers', params: params_provider

        expect(status).to eq(201)
        expect(json['id']).to                        be_present
        expect(json['attributes']['slug']).to        eq('third-test-layer')
        expect(json['attributes']['provider']).to    eq('not valid provider')
        expect(json['attributes']['application']).to eq('not valid application')
      end

      it 'Name and slug validation' do
        post '/layers', params: params_faild

        expect(status).to eq(422)
        expect(json_main['success']).to         eq(false)
        expect(json_main['message']['name']).to eq(['is already taken'])
        expect(json_main['message']['slug']).to eq(['is already taken'])
      end

      it 'Allows to update layer' do
        put "/layers/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to                 eq(layer_id)
        expect(json['attributes']['name']).to eq('First test layer update')
        expect(json['attributes']['slug']).to eq('test-layer-slug')
      end

      it 'Allows to delete layer by id' do
        delete "/layers/#{layer_id}"

        expect(status).to eq(200)
        expect(json_main['message']).to      eq('Layer deleted')
        expect(Layer.where(id: layer_id)).to be_empty
      end

      it 'Allows to delete layer by slug' do
        delete "/layers/#{layer_slug}"

        expect(status).to eq(200)
        expect(json_main['message']).to          eq('Layer deleted')
        expect(Layer.where(slug: layer_slug)).to be_empty
      end
    end
  end
end
