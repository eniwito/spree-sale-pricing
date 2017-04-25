Deface::Override.new(
  virtual_path: "spree/admin/products/_form",
  name: "modify_price_field",
  replace: "[data-hook='admin_product_form_price']",
  partial: "spree/admin/shared/price_field",
)
