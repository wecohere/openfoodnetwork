require 'spec_helper'

describe PropertyObserver do
  let(:product_property) { create(:product_property) }
  let(:property) { product_property.property }
  let(:product) { product_property.product }

  it "refreshes the products cache on save" do
    expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(product)
    property.name = 'asdf'
    property.save
  end
end

