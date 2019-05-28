require 'spec_helper'

describe ProductObserver do
  let(:product) { create(:simple_product) }

  it "refreshes the products cache on save" do
    expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(product)
    product.name = 'asdf'
    product.save
  end
end
