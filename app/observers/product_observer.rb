class ProductObserver < ActiveRecord::Observer

  def after_save(product)
    OpenFoodNetwork::ProductsCache.product_changed(product)
  end
end
