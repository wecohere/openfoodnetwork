class ProductObserver < ActiveRecord::Observer
  observe Spree::Product

  def after_save(product)
    OpenFoodNetwork::ProductsCache.product_changed(product)
  end
end
