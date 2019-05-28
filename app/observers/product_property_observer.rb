class ProductPropertyObserver < ActiveRecord::Observer
  observe Spree::ProductProperty

  def after_save(product_property)
    OpenFoodNetwork::ProductsCache.product_changed(product_property.product)
  end

  def after_destroy(product_property)
    OpenFoodNetwork::ProductsCache.product_changed(product_property.product)
  end
end
