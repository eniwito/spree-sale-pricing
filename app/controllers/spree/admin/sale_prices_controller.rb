module Spree
  module Admin
    class SalePricesController < BaseController

      before_filter :load_product

      respond_to :js, :html

      def index
        @sale_prices = @product.master.sale_prices.order(created_at: :asc)
      end

      def create
        @sale_price = @product.put_on_sale params[:sale_price][:value], sale_price_params
        respond_with(@sale_price)
      end

      def destroy
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.destroy
        respond_with(@sale_price)
      end

      def disable
        @sale_price = Spree::SalePrice.find(params[:id])
        @sale_price.disable
        flash[:success] = Spree.t('spree_sale_price.disable_notify')
        redirect_to admin_product_sale_prices_path
      end

      def enable
        @sale_prices = @product.master.sale_prices.order(created_at: :asc)
        @sale_price = Spree::SalePrice.find(params[:id])
        if @sale_prices.where(enabled: true).count >= 1
          flash[:error] = Spree.t('spree_sale_price.exist_enabled_notify')
        else
          @sale_price.enable
          flash[:success] = Spree.t('spree_sale_price.enable_notify')
        end
        redirect_to admin_product_sale_prices_path
      end

      private

      def load_product
        @product = Spree::Product.find_by(slug: params[:product_id])
        redirect_to request.referer unless @product.present?
      end

      def sale_price_params
        params.require(:sale_price).permit(
            :id,
            :value,
            :kind,
            :currency,
            :start_at,
            :end_at,
            :enabled
        )
      end

    end
  end
end
