require 'acceptance_helper'

module V1
  describe 'Layers', type: :request do
    context 'Create, update and delete layers' do
      let!(:data) {{"marks": {
                    "type": "rect",
                    "from": {
                      "data": "table"
                  }}}}

      let!(:params) {{ "loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"},
                       "layer": { "application": ["GFW"],
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

      let!(:new_params) {{ "loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"},
                           "layer": { "application": ["GFW"],
                                      "name": "second-test-layer",
                                      "provider": "Cartodb",
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

      let!(:params_provider) {{ "loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"},
                                "layer": { "application": ["gfw"],
                                           "name": "third-test-layer",
                                           "provider": "Test"
                                          }}}

      let!(:params_faild)  {{"loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"}, "layer": { "name": "Layer second one", "application_config": data, "application": ["gfw"] }}}
      let!(:update_params) {{"loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"}, "layer": { "name": "First test layer update", "slug": "test-layer-slug", "application_config": data, "application": ["gfw"] }}}

      let!(:layer) {
        Layer.create!(name: 'Layer second one', published: true, status: 1, application: ['gfw'], dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg', user_id: '3242-32442-432')
      }

      let!(:default_layer) {
        Layer.create!(name: 'Layer first one', published: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg', application: ['WRW'], user_id: '3242-32442-432')
      }

      let!(:next_layer) {
        Layer.create!(name: 'Next first one', published: true, application: ['WRW'], dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddh', user_id: '3242-32442-432')
      }

      let!(:layer_id)   { layer.id   }
      let!(:layer_slug) { layer.slug }

      context 'List filters' do
        let!(:disabled_layer) {
          Layer.create!(name: 'Layer second second', slug: 'layer-second-second', application: ['prep'], status: 3, published: false, user_id: '3242-32442-432')
        }

        let!(:enabled_layer) {
          Layer.create!(name: 'Layer one', status: 1, published: true, application: ['Wrw'], user_id: '3242-32442-432')
        }

        let!(:unpublished_layer) {
          Layer.create!(name: 'Layer one unpublished', status: 1, application: ['gfw'], published: false, user_id: '3242-32442-432')
        }

        it 'Show list of all layers' do
          get '/layer?status=all'

          expect(status).to eq(200)
          expect(json.size).to eq(6)
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

      it 'Show layer by dataset and slug' do
        get "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_slug}"

        expect(status).to eq(200)
        expect(json['attributes']['slug']).to     eq('layer-second-one')
        expect(json_main['meta']['status']).to    eq('saved')
        expect(json_main['meta']['published']).to eq(true)
      end

      it 'Show layer by dataset and id' do
        get "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_id}"

        expect(status).to eq(200)
      end

      it 'Not valid layer by dataset and id' do
        get "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddf/layer/#{layer_id}"

        expect(status).to eq(404)
      end

      it 'Allows to create second layer' do
        post '/layer', params: params

        expect(status).to eq(201)
        expect(json['id']).to                          be_present
        expect(json['attributes']['slug']).to          eq('second-test-layer')
        expect(json['attributes']['provider']).to      eq('cartodb')
        expect(json['attributes']['dataset']).to       eq('c867138c-eccf-4e57-8aa2-b62b87800ddf')
        expect(json['attributes']['application']).to   eq(['gfw'])
        expect(json['attributes']['legendConfig']).to eq({"marks"=>{"type"=>"rect", "from"=>{"data"=>"table"}}})
      end

      it 'Allows to create dataset layer' do
        post '/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddf/layer', params: new_params

        expect(status).to eq(201)
        expect(json['id']).to                         be_present
        expect(json['attributes']['slug']).to         eq('second-test-layer')
        expect(json['attributes']['provider']).to     eq('cartodb')
        expect(json['attributes']['dataset']).to      eq('c867138c-eccf-4e57-8aa2-b62b87800ddf')
        expect(json['attributes']['application']).to  eq(['gfw'])
        expect(json['attributes']['userId']).to       eq('3242-32442-432')
        expect(json['attributes']['legendConfig']).to eq({"marks"=>{"type"=>"rect", "from"=>{"data"=>"table"}}})
      end

      it 'Allows to create layer with not valid provider' do
        post '/layer', params: params_provider

        expect(status).to eq(422)
        expect(json_main['errors'][0]['title']).to eq(['Provider not valid'])
      end

      it 'Name and slug validation' do
        post '/layer', params: params_faild

        expect(status).to eq(422)
        expect(json_main['errors'][0]['title']).to eq(['Name is already taken', 'Slug is already taken'])
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

      it 'Allows to update dataset layer via put' do
        put "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to                 eq(layer_id)
        expect(json['attributes']['name']).to eq('First test layer update')
        expect(json['attributes']['slug']).to eq('test-layer-slug')
      end

      it 'Allows to update dataset layer via patch' do
        patch "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_slug}", params: update_params

        expect(status).to eq(200)
        expect(json['id']).to                 eq(layer_id)
        expect(json['attributes']['name']).to eq('First test layer update')
        expect(json['attributes']['slug']).to eq('test-layer-slug')
      end

      it 'Allows to delete layer by id' do
        delete "/layer/#{layer_id}", params: { "loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"} }

        expect(status).to eq(200)
        expect(json_main['message']).to      eq('Layer deleted')
        expect(Layer.where(id: layer_id)).to be_empty
      end

      it 'Allows to delete layer by slug' do
        delete "/layer/#{layer_slug}", params: { "loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep","wrw"] }, "id": "3242-32442-432"} }

        expect(status).to eq(200)
        expect(json_main['message']).to          eq('Layer deleted')
        expect(Layer.where(slug: layer_slug)).to be_empty
      end

      it 'Allows to delete layer by dataset and id' do
        delete "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_id}", params: { "loggedUser": "{\"role\": \"manager\", \"extraUserData\": { \"apps\": [\"gfw\",\"prep\",\"wrw\"] }, \"id\": \"3242-32442-432\"}" }

        expect(status).to eq(200)
        expect(json_main['message']).to      eq('Layer deleted')
        expect(Layer.where(id: layer_id)).to be_empty
      end

      it 'Allows to delete layer by dataset and slug' do
        delete "/dataset/c867138c-eccf-4e57-8aa2-b62b87800ddg/layer/#{layer_slug}", params: { "loggedUser": "{\"role\": \"manager\", \"extraUserData\": { \"apps\": [\"gfw\",\"prep\",\"wrw\"] }, \"id\": \"3242-32442-432\"}"}

        expect(status).to eq(200)
        expect(json_main['message']).to          eq('Layer deleted')
        expect(Layer.where(slug: layer_slug)).to be_empty
      end

      context 'Check roles' do
        it 'Do not allows to create layer by an user' do
          post '/layer', params: {"loggedUser": {"role": "user", "extraUserData": { "apps": ["gfw","prep"] }, "id": "3242-32442-432"},
                                    "layer": {"name": "Widget", "application": ["gfw"] }}

          expect(status).to eq(401)
          expect(json_main['errors'][0]['title']).to eq('Not authorized!')
        end

        it 'Do not allows to create layer by manager user if not in apps' do
          post '/layer', params: {"loggedUser": {"role": "manager", "extraUserData": { "apps": ["gfw","prep"] }, "id": "3242-32442-432"},
                                    "layer": {"name": "Widget", "application": ["wri"] }}

          expect(status).to eq(401)
          expect(json_main['errors'][0]['title']).to eq('Not authorized!')
        end

        it 'Allows to update layer by admin user if in apps' do
          patch "/layer/#{layer_id}", params: {"loggedUser": {"role": "Admin", "extraUserData": { "apps": ["gfw", "wrw","prep"] }, "id": "3242-32442-436"},
                                                 "layer": {"name": "Carto test api Widget"}}

          expect(status).to eq(200)
          expect(json_attr['name']).to        eq('Carto test api Widget')
          expect(json_attr['application']).to eq(["gfw"])
        end

        it 'Do not allow to update layer by admin user if not in apps' do
          patch "/layer/#{layer_id}", params: {"loggedUser": {"role": "Admin", "extraUserData": { "apps": ["prep"] }, "id": "3242-32442-436"},
                                                 "layer": {"application": ["gfw"],
                                                            "name": "Carto test api"}}

          expect(status).to eq(401)
          expect(json_main['errors'][0]['title']).to eq('Not authorized!')
        end

        it 'Allows to update layer by superadmin user' do
          patch "/layer/#{layer_id}", params: {"loggedUser": {"role": "Superadmin", "extraUserData": { }, "id": "3242-32442-436"},
                                                 "layer": {"application": ["testapp"],
                                                            "name": "Widget"}}

          expect(status).to eq(200)
          expect(json_attr['name']).to        eq('Widget')
          expect(json_attr['application']).to eq(["testapp"])
        end

        it 'Allows to update layer by admin user if in apps changing apps' do
          patch "/layer/#{layer_id}", params: {"loggedUser": {"role": "Admin", "extraUserData": { "apps": ["gfw", "wrw", "prep","testapp"] }, "id": "3242-32442-436"},
                                                 "layer": {"application": ["testapp"],
                                                            "name": "Widget additional apps"}}

          expect(status).to eq(200)
          expect(json_attr['name']).to        eq('Widget additional apps')
          expect(json_attr['application']).to eq(["testapp"])
        end
      end
    end
  end
end
