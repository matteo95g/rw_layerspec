# frozen_string_literal: true
module V1
  class LayersController < ApplicationController
    before_action :set_layer,  only: [:show, :update, :destroy]

    def index
      @layers = Layer.fetch_all(layer_type_filter)
      render json: @layers, each_serializer: LayerSerializer, meta: { layersCount: @layers.size }
    end

    def by_datasets
      @layers = Layer.fetch_by_datasets(layer_datasets_filter)
      render json: @layers, each_serializer: LayerSerializer, meta: { layersCount: @layers.size }
    end

    def show
      render json: @layer, serializer: LayerSerializer, meta: { status: @layer.try(:status_txt),
                                                                published: @layer.try(:published),
                                                                updatedAt: @layer.try(:updated_at),
                                                                createdAt: @layer.try(:created_at) }
    end

    def update
      if @layer.update(layer_params)
        render json: @layer, status: 200, serializer: LayerSerializer, meta: { status: @layer.try(:status_txt),
                                                                               published: @layer.try(:published),
                                                                               updatedAt: @layer.try(:updated_at),
                                                                               createdAt: @layer.try(:created_at) }
      else
        render json: { success: false, message: @layer.errors }, status: 422
      end
    end

    def create
      @layer = Layer.new(layer_params)
      if @layer.save
        render json: @layer, status: 201, serializer: LayerSerializer, meta: { status: @layer.try(:status_txt),
                                                                               published: @layer.try(:published),
                                                                               updatedAt: @layer.try(:updated_at),
                                                                               createdAt: @layer.try(:created_at) }
      else
        render json: { success: false, message: @layer.errors }, status: 422
      end
    end

    def destroy
      @layer.destroy
      begin
        render json: { message: 'Layer deleted' }, status: 200
      rescue ActiveRecord::RecordNotDestroyed
        return render json: @layer.erors, message: 'Layer could not be deleted', status: 422
      end
    end

    private

      def set_layer
        @layer = Layer.set_by_id_or_slug(params[:id])
        record_not_found if @layer.blank?
      end

      def layer_type_filter
        params.permit(:status, :published, :app, :dataset)
      end

      def layer_datasets_filter
        params.require(:layer).permit(ids: [], app: [])
      end

      def layer_params
        params.require(:layer).permit!
      end
  end
end
