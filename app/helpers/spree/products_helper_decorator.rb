Spree::ProductsHelper.module_eval do
  def cache_key_for_products
    count = @products.count
    max_updated_at = (@products.map(&:updated_at).max || Date.today).to_s(:number)
    "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}"
  end
end