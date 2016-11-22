require 'acceptance_helper'

module V1
  describe 'Layers', type: :request do
    let!(:layer) {
      Layer.create!(name: 'Layer second one', published: true, status: 1, application: 'gfw', dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg', user_id: '3242-32442-432')
    }

    let!(:default_layer) {
      Layer.create!(name: 'AAA Layer first one', published: true, dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddg', application: 'WRW', user_id: '3242-32442-432')
    }

    let!(:next_layer) {
      Layer.create!(name: 'Next first one', published: true, application: 'WRW', dataset_id: 'c867138c-eccf-4e57-8aa2-b62b87800ddh', user_id: '3242-32442-432')
    }

    context 'List filters' do
      let!(:disabled_layer) {
        Layer.create!(name: 'Layer second second', slug: 'layer-second-second', status: 3, published: false, user_id: '3242-32442-432')
      }

      let!(:enabled_layer) {
        Layer.create!(name: 'Layer one', status: 1, published: true, application: 'Wrw', user_id: '3242-32442-432')
      }

      let!(:unpublished_layer) {
        Layer.create!(name: 'ZZZ Layer last unpublished', status: 1, published: false, user_id: '3242-32442-432')
      }

      it 'Show list of layers with pending status' do
        get '/layer?status=pending'

        expect(status).to eq(200)
        expect(json.size).to eq(0)
      end

      it 'Show list of layers with active status' do
        get '/layer?status=active'

        expect(status).to eq(200)
        expect(json.size).to eq(4)
      end

      it 'Show list of layers with disabled status' do
        get '/layer?status=disabled'

        expect(status).to eq(200)
        expect(json.size).to eq(1)
      end

      it 'Show list of layers with published status true' do
        get '/layer?published=true'

        expect(status).to eq(200)
        expect(json.size).to eq(4)
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
        expect(json.size).to eq(3)
      end

      it 'Show blank list of layers for not existing app' do
        get '/layer?app=notexisting'

        expect(status).to eq(200)
        expect(json.size).to eq(0)
      end

      it 'Show list of layers' do
        get '/layer'

        expect(status).to eq(200)
        expect(json.size).to eq(4)
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

      it 'Filter by dataset ids' do
        post '/layer/find-by-ids', params: { "layer": { "ids": ["c867138c-eccf-4e57-8aa2-b62b87800ddg", "c867138c-eccf-4e57-8aa2-b62b87800ddh"] } }

        expect(status).to eq(200)
        expect(json.size).to eq(3)
      end

      it 'Filter by dataset ids and apps' do
        post '/layer/find-by-ids', params: { "layer": { "ids": ["c867138c-eccf-4e57-8aa2-b62b87800ddg", "c867138c-eccf-4e57-8aa2-b62b87800ddh"], "app": ["wrw"] } }

        expect(status).to eq(200)
        expect(json.size).to eq(2)
      end

      it 'Filter by dataset ids and apps' do
        post '/layer/find-by-ids', params: { "layer": { "ids": ["c867138c-eccf-4e57-8aa2-b62b87800ddg", "c867138c-eccf-4e57-8aa2-b62b87800ddh"], "app": ["prep", "test", "gfw"] } }

        expect(status).to eq(200)
        expect(json.size).to eq(1)
      end

      it 'Filter by dataset ids and apps' do
        post '/layer/find-by-ids', params: { "layer": { "ids": ["c867138c-eccf-4e57-8aa2-b62b87800ddg", "c867138c-eccf-4e57-8aa2-b62b87800ddh"], "app": ["prep", "test"] } }

        expect(status).to eq(200)
        expect(json.size).to eq(0)
      end

      it 'Filter by non existing dataset ids' do
        post '/layer/find-by-ids', params: { "layer": { "ids": ["c867138c-eccf-4e57-8aa2-b62b87800ddx"] } }

        expect(status).to eq(200)
        expect(json.size).to eq(0)
      end

      it 'Show blank list of layers for all apps and second page (for total items 6)' do
        get '/layer?page[number]=2&page[size]=10&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(0)
      end

      it 'Show list of layers for all apps first page' do
        get '/layer?page[number]=1&page[size]=10&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(6)
      end

      it 'Show list of layers for all apps first page with per pege param' do
        get '/layer?page[number]=1&page[size]=3&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of layers for all apps second page with per pege param' do
        get '/layer?page[number]=2&page[size]=3&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(3)
      end

      it 'Show list of layers for all apps sort by name' do
        get '/layer?sort=name&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(6)
        expect(json[0]['attributes']['name']).to eq('AAA Layer first one')
      end

      it 'Show list of layers for all apps sort by name DESC' do
        get '/layer?sort=-name&status=all'

        expect(status).to eq(200)
        expect(json.size).to eq(6)
        expect(json[0]['attributes']['name']).to eq('ZZZ Layer last unpublished')
      end
    end
  end
end
