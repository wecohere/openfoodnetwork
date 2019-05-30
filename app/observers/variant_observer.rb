class VariantObserver < ActiveRecord::Observer
  observe Spree::Variant

  def after_save(variant)
    if variant.is_master?
      OpenFoodNetwork::ProductsCache.product_changed(variant.product)
    else
      OpenFoodNetwork::ProductsCache.variant_changed(variant)
    end
  end
end
