class PriceObserver < ActiveRecord::Observer
  observe Spree::Price

  def after_save(price)
    OpenFoodNetwork::ProductsCache.variant_changed(price.variant)
  end
end
