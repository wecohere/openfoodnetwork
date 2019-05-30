require 'spec_helper'

describe VariantObserver do
  let!(:variant) { create(:variant) }

  before(:all) do
    ActiveRecord::Base.observers.disable(:all)
  end

  after(:all) do
    ActiveRecord::Base.observers.enable(:all)
  end

  around(:each) do |example|
    ActiveRecord::Base.observers.enable(:variant_observer) do
      example.run
    end
  end

  context "when it is not the master variant" do
    it "refreshes the products cache on save" do
      expect(OpenFoodNetwork::ProductsCache).to receive(:variant_changed).with(variant)
      variant.sku = 'abc123'
      variant.save
    end

    it "refreshes the products cache on destroy" do
      expect(OpenFoodNetwork::ProductsCache).to receive(:variant_destroyed).with(variant)
      variant.destroy
    end
  end

  context "when it is the master variant" do
    let!(:product) { create(:simple_product) }
    let!(:master) { product.master }

    it "refreshes the products cache for the entire product on save" do
      expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(product)
      expect(OpenFoodNetwork::ProductsCache).to receive(:variant_changed).never

      master.sku = 'abc123'
      master.save
    end

    it "refreshes the products cache for the entire product on destroy" do
      expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(product)
      expect(OpenFoodNetwork::ProductsCache).to receive(:variant_destroyed).never
      master.destroy
    end
  end
end
