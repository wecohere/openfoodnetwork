# frozen_string_literal: true

require "open_food_network/i18n_inflections"

module OpenFoodNetwork
  class OptionValueNamer
    def initialize(variant = nil)
      @variant = variant
    end

    def name(obj = nil)
      @variant = obj unless obj.nil?
      value, unit = option_value_value_unit
      separator = value_scaled? ? '' : ' '

      name_fields = []
      name_fields << "#{value}#{separator}#{unit}" if value.present? && unit.present?
      name_fields << @variant.unit_description if @variant.unit_description.present?
      name_fields.join ' '
    end

    def value
      value, = option_value_value_unit
      value
    end

    def unit
      _, unit = option_value_value_unit
      unit
    end

    private

    def value_scaled?
      @variant.product.variant_unit_scale.present?
    end

    def option_value_value_unit
      if @variant.unit_value.present?
        if %w(weight volume).include? @variant.product.variant_unit
          value, unit_name = option_value_value_unit_scaled

        else
          value = @variant.unit_value
          unit_name = pluralize(@variant.product.variant_unit_name, value)
        end

        value = value.to_i if value == value.to_i

      else
        value = unit_name = nil
      end

      [value, unit_name]
    end

    def option_value_value_unit_scaled
      unit_scale, unit_name = scale_for_unit_value

      value = @variant.unit_value / unit_scale

      [value, unit_name]
    end

    def scale_for_unit_value
      # TODO: We _think_ this will cause the following weird results:
      #   29g of product would use the `oz` measurement
      #   445g of product would use the `lb` measurement
      # So we probably want to keep the metric and imperial measures
      # in their own lanes; perhaps using a configurable value on a per
      # shop or producer basis?

      units = { 'weight' => { 1.0 => 'g', 1000.0 => 'kg', 1_000_000.0 => 'T',
                              28.34952 => 'oz', 453.59237 => 'lb'},
                'volume' => { 0.001 => 'mL', 1.0 => 'L',  1000.0 => 'kL' } }

      # Find the largest available unit where unit_value comes to >= 1 when expressed in it.
      # If there is none available where this is true, use the smallest available unit.
      unit = units[@variant.product.variant_unit].select { |scale, _unit_name|
        @variant.unit_value / scale >= 1
      }.to_a.last
      unit = units[@variant.product.variant_unit].first if unit.nil?

      unit
    end

    def pluralize(unit_name, count)
      I18nInflections.pluralize(unit_name, count)
    end
  end
end
