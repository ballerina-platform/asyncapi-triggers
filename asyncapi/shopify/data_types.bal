// Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Listener related configurations should be included here
@display {label: "Listener Config"}
public type ListenerConfig record {
    @display {label: "API Secret Key", "description": "The Shopify API secret key, viewable under `Webhooks` in the Shopify admin dashboard (if the webhook is created using the dashboard) or under `API credentials` in the Shopify App (if the webhook is created programatically)"}
    string apiSecretKey;
};

public type Address record {
    # The customer's postal code, also known as zip, postcode, Eircode, etc.
    string? zip?;
    # The customer's country.
    string? country?;
    # An additional field for the customer's mailing address.
    string? 'address2?;
    # The customer's city, town, or village.
    string? city?;
    # The customer's mailing address.
    string? 'address1?;
    # The customer's last name.
    string? last_name?;
    # The two-letter code for the customer's region.
    string? province_code?;
    # The two-letter country code corresponding to the customer's country.
    string? country_code?;
    # Returns true for each default address.
    boolean? 'default?;
    # The customer's region name. Typically a province, a state, or a prefecture.
    string? province?;
    # The customer's phone number at this address.
    string? phone?;
    # The customer's normalized country name.
    string? country_name?;
    # The customer's first and last names.
    string? name?;
    # The customer's company.
    string? company?;
    # A unique identifier for the address.
    int? id?;
    # A unique identifier for the customer.
    int? customer_id?;
    # The customer's first name.
    string? first_name?;
};

public type OrderAdjustment record {
    # The taxes that are added to amount, such as applicable shipping taxes added to a shipping refund.
    string? tax_amount?;
    # The reason for the order adjustment. To set this value, include discrepancy_reason when you create a refund.
    string? reason?;
    # The value of the discrepancy between the calculated refund and the actual refund. If the kind property's value is shipping_refund, then amount returns the value of shipping charges refunded to the customer.
    int? amount?;
    # The order adjustment type. Valid values are shipping_refund and refund_discrepancy.
    string? kind?;
    # The unique identifier for the order adjustment.
    int? id?;
    # The unique identifier for the order that the order adjustment is associated with.
    int? order_id?;
    # The unique identifier for the refund that the order adjustment is associated with.
    int? refund_id?;
};

public type Customer record {
    # A note about the customer.
    string? note?;
    # A list of the ten most recently updated addresses for the customer.
    Address[]? addresses?;
    # The name of the customer's last order. This is directly related to the name field on the Order resource.
    string? last_order_name?;
    # The date and time (ISO 8601 format) when the customer was created.
    string? created_at?;
    # A unique identifier for the customer that's used with Multipass login.
    string? multipass_identifier?;
    # The date and time (ISO 8601 format) when the customer consented or objected to receiving marketing material by email. Set this value whenever the customer consents or objects to marketing materials.
    string? accepts_marketing_updated_at?;
    Address? default_address?;
    # The date and time (ISO 8601 format) when the customer information was last updated.
    string? updated_at?;
    # Whether the customer has consented to receive marketing material via email.
    boolean? accepts_marketing?;
    # The three-letter code (ISO 4217 format) for the currency that the customer used when they paid for their last order. Defaults to the shop currency. Returns the shop currency for test orders.
    string? currency?;
    # A unique identifier for the customer.
    int? id?;
    # The marketing subscription opt-in level (as described by the M3AAWG best practices guideline) that the customer gave when they consented to receive marketing material by email. If the customer does not accept email marketing, then this property will be set to null.
    string? marketing_opt_in_level?;
    # The state of the customer's account with a shop. Default value is disabled.
    string? state?;
    # The customer's first name.
    string? first_name?;
    # The unique email address of the customer. Attempting to assign the same email address to multiple customers returns an error.
    string? email?;
    # The total amount of money that the customer has spent across their order history.
    string? total_spent?;
    # The ID of the customer's last order.
    int? last_order_id?;
    # Whether the customer is exempt from paying taxes on their order. If true, then taxes won't be applied to an order at checkout. If false, then taxes will be applied at checkout.
    boolean? tax_exempt?;
    # The customer's last name.
    string? last_name?;
    # Whether the customer has verified their email address.
    boolean? verified_email?;
    # Tags that the shop owner has attached to the customer, formatted as a string of comma-separated values. A customer can have up to 250 tags. Each tag can have up to 255 characters.
    string? tags?;
    # The number of orders associated with this customer.
    int? orders_count?;
    SmsMarketingConsent? sms_marketing_consent?;
    Metafield? metafield?;
    # The unique phone number (E.164 format) for this customer. Attempting to assign the same phone number to multiple customers returns an error. The property can be set using different formats, but each format must represent a number that can be dialed from anywhere in the world.
    string? phone?;
    # Whether the customer is exempt from paying specific taxes on their order. Canadian taxes only.
    string[]? tax_exemptions?;
};

public type TotalTaxSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type ProductImage record {
    # The date and time when the product image was last modified. The API returns this value in ISO 8601 format.
    string? updated_at?;
    # Specifies the location of the product image. This parameter supports URL filters that you can use to retrieve modified copies of the image. For example, add _small, to the filename to retrieve a scaled copy of the image at 100 x 100 px (for example, ipod-nano_small.png), or add _2048x2048 to retrieve a copy of the image constrained at 2048 x 2048 px resolution (for example, ipod-nano_2048x2048.png).
    string? src?;
    # The id of the product associated with the image.
    int? product_id?;
    # Admin GraphQL API ID.
    string? admin_graphql_api_id?;
    # Width dimension of the image which is determined on upload.
    int? width?;
    # The date and time when the product image was created. The API returns this value in ISO 8601 formatting.
    string? created_at?;
    # An array of variant ids associated with the image.
    int[]? variant_ids?;
    # A unique numeric identifier for the product image.
    int? id?;
    # The order of the product image in the list. The first product image is at position 1 and is the "main" image for the product.
    int? position?;
    # Height dimension of the image which is determined on upload.
    int? height?;
};

public type DiscountApplication record {
    # The method by which the discount application value has been allocated to entitled lines. = ['across', 'each', 'one']
    string? allocation_method?;
    # The type of the value = ['percentage', 'fixed_amount']
    string? value_type?;
    # The type of line on the order that the discount is applicable on = ['line_item', 'shipping_line']
    string? target_type?;
    # The lines on the order, of the type defined by target_type, that the discount is allocated over = ['all', 'entitled', 'explicit']
    string? target_selection?;
    # The description of the discount application, as defined by the merchant or the Shopify Script. Available only for manual and script discount applications
    string? description?;
    # The discount application type.Valid values:manual The discount was manually applied by the merchant (for example, by using an app or creating a draft order).script: The discount was applied by a Shopify Script.discount_code: The discount was applied by a discount code. = ['discount_code', 'manual', 'script']
    string? 'type?;
    # The title of the discount application, as defined by the merchant. Available only for manual discount applications
    string? title?;
    # The value of the discount application as a decimal. This represents the intention of the discount application
    string? value?;
};

public type PriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type PaymentTerms record {
    # The type of selected payment terms template for the order.
    string? payment_terms_type?;
    # The amount that is owed according to the payment terms.
    int? amount?;
    # The name of the selected payment terms template for the order.
    string? payment_terms_name?;
    # The number of days between the invoice date and due date that is defined in the selected payment terms template.
    int? due_in_days?;
    # The presentment currency for the payment.
    string? currency?;
    # An array of schedules associated to the payment terms.
    PaymentSchedule[]? payment_schedules?;
};

public type DiscountedPriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type TaxLine record {
    # Whether the channel that submitted the tax line is liable for remitting. A value of null indicates unknown liability for the tax line.
    boolean? channel_liable?;
    # The rate of tax to be applied.
    decimal? rate?;
    # The amount of tax to be charged in the shop currency.
    string? price?;
    # The name of the tax.
    string? title?;
};

public type CustomerEvent record {
    # The total amount of money that the customer has spent across their order history.
    string? total_spent?;
    # A note about the customer.
    string? note?;
    # A list of the ten most recently updated addresses for the customer.
    Address[]? addresses?;
    # The name of the customer's last order. This is directly related to the name field on the Order resource.
    string? last_order_name?;
    # The ID of the customer's last order.
    int? last_order_id?;
    # Whether the customer is exempt from paying taxes on their order. If true, then taxes won't be applied to an order at checkout. If false, then taxes will be applied at checkout.
    boolean? tax_exempt?;
    # The date and time (ISO 8601 format) when the customer was created.
    string? created_at?;
    # The customer's last name.
    string? last_name?;
    # A unique identifier for the customer that's used with Multipass login.
    string? multipass_identifier?;
    # Whether the customer has verified their email address.
    boolean? verified_email?;
    # Tags that the shop owner has attached to the customer, formatted as a string of comma-separated values. A customer can have up to 250 tags. Each tag can have up to 255 characters.
    string? tags?;
    # The date and time (ISO 8601 format) when the customer consented or objected to receiving marketing material by email. Set this value whenever the customer consents or objects to marketing materials.
    string? accepts_marketing_updated_at?;
    # The number of orders associated with this customer.
    int? orders_count?;
    SmsMarketingConsent? sms_marketing_consent?;
    # The date and time (ISO 8601 format) when the customer information was last updated.
    string? updated_at?;
    # Whether the customer has consented to receive marketing material via email.
    boolean? accepts_marketing?;
    # The unique phone number (E.164 format) for this customer. Attempting to assign the same phone number to multiple customers returns an error. The property can be set using different formats, but each format must represent a number that can be dialed from anywhere in the world.
    string? phone?;
    # Admin GraphQL API ID
    string? admin_graphql_api_id?;
    # The three-letter code (ISO 4217 format) for the currency that the customer used when they paid for their last order. Defaults to the shop currency. Returns the shop currency for test orders.
    string? currency?;
    # A unique identifier for the customer.
    int? id?;
    # The state of the customer's account with a shop. Default value is disabled.
    string? state?;
    # The marketing subscription opt-in level (as described by the M3AAWG best practices guideline) that the customer gave when they consented to receive marketing material by email. If the customer does not accept email marketing, then this property will be set to null.
    string? marketing_opt_in_level?;
    # The customer's first name.
    string? first_name?;
    # The unique email address of the customer. Attempting to assign the same email address to multiple customers returns an error.
    string? email?;
};

public type TotalPriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type TotalLineItemsPriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type TotalDiscountSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type PresentmentPrices record {
    # A list of the variant's presentment prices and compare-at prices in each of the shop's enabled presentment currencies.
    PresentmentPrice[]? presentment_prices?;
};

public type ProductVariant record {
    PresentmentPrices? presentment_prices?;
    # The fulfillment service that tracks the number of items in stock for the product variant.
    string? inventory_management?;
    # This property is deprecated. Use the InventoryLevel resource instead.
    int? old_inventory_quantity?;
    # This property is deprecated. Use the `requires_shipping` property on the InventoryItem resource instead.
    boolean? requires_shipping?;
    # The date and time (ISO 8601 format) when the product variant was created.
    string? created_at?;
    # The title of the product variant. The title field is a concatenation of the option1, option2, and option3 fields. You can only update title indirectly using the option fields.
    string? title?;
    # This property is deprecated. Use the InventoryLevel resource instead.
    int? inventory_quantity_adjustment?;
    # The date and time when the product variant was last modified. Gets returned in ISO 8601 formatting.
    string? updated_at?;
    # The unique identifier for the inventory item, which is used in the Inventory API to query for inventory information.
    int? inventory_item_id?;
    # The price of the product variant.
    string? price?;
    # The unique numeric identifier for the product.
    int? product_id?;
    # The unique numeric identifier for the product variant.
    int? id?;
    # The weight of the product variant in grams.
    int? grams?;
    # A unique identifier for the product variant in the shop. Required in order to connect to a FulfillmentService.
    string? sku?;
    # The barcode, UPC, or ISBN number for the product.
    string? barcode?;
    # An aggregate of inventory across all locations. To adjust inventory at a specific location, use the InventoryLevel resource.
    int? inventory_quantity?;
    # The original price of the item before an adjustment or a sale.
    string? compare_at_price?;
    # The fulfillment service associated with the product variant. Valid values are manual or the handle of a fulfillment service.
    string? fulfillment_service?;
    # Whether a tax is charged when the product variant is sold.
    boolean? taxable?;
    # The weight of the product variant in the unit system specified with weight_unit.
    int? weight?;
    # Whether customers are allowed to place an order for the product variant when it's out of stock.
    string? inventory_policy?;
    # This parameter applies only to the stores that have the Avalara AvaTax app installed. Specifies the Avalara tax code for the product variant.
    string? tax_code?;
    # The unit of measurement that applies to the product variant's weight. If you don't specify a value for weight_unit, then the shop's default unit of measurement is applied. Valid values are g, kg, oz, and lb.
    string? weight_unit?;
    # The order of the product variant in the list of product variants. The first position in the list is 1. The position of variants is indicated by the order in which they are listed.
    int? position?;
    # The unique numeric identifier for a product's image. The image must be associated to the same product as the variant.
    int? image_id?;
    Option? option?;
};

public type FulfillmentEvent record {
    Address? destination?;
    # The date and time when the fulfillment was created. The API returns this value in ISO 8601 format
    string? created_at?;
    Address? origin_address?;
    # The name of the tracking company.
    string? tracking_company?;
    # A historical record of each item in the fulfillment.
    LineItem[]? line_items?;
    # The URLs of tracking pages for the fulfillment.
    string[]? tracking_urls?;
    # The unique identifier of the location that the fulfillment should be processed for. To find the ID of the location, use the Location resource.
    int? location_id?;
    # The date and time (ISO 8601 format) when the fulfillment was last modified.
    string? updated_at?;
    # The type of service used.
    string? 'service?;
    # Admin GraphQL API ID.
    string? admin_graphql_api_id?;
    # The uniquely identifying fulfillment name, consisting of two parts separated by a .. The first part represents the order name and the second part represents the fulfillment number. The fulfillment number automatically increments depending on how many fulfillments are in an order (e.g. #1001.1, #1001.2).
    string? name?;
    # A tracking number, provided by the shipping company.
    string? tracking_number?;
    Receipt? receipt?;
    # The ID for the fulfillment.
    int? id?;
    # A list of tracking numbers, provided by the shipping company.
    string[]? tracking_numbers?;
    # The unique numeric identifier for the order.
    int? order_id?;
    # The URL of tracking pages for the fulfillment.
    string? tracking_url?;
    # Email.
    string? email?;
    # The status of the fulfillment.
    string? status?;
    # The current shipment status of the fulfillment.
    string? shipment_status?;
};

public type Property record {
    # Property name
    string? name?;
    # Property value
    string? value?;
};

public type RefundLineItem record {
    # The ID of the related line item in the order.
    int? line_item_id?;
    # The quantity of the associated line item that was returned.
    int? quantity?;
    # The subtotal of the refund line item.
    decimal? subtotal?;
    # The unique identifier of the line item in the refund.
    int? id?;
    # The total tax on the refund line item.
    decimal? total_tax?;
    # The unique identifier of the location where the items will be restocked. Required when restock_type has the value return or cancel.
    int? location_id?;
    # How this refund line item affects inventory levels.
    string? restock_type?;
};

public type ProductEvent record {
    # A description of the product. Supports HTML formatting.
    string? body_html?;
    # A list of product image objects, each one representing an image associated with the product.
    ProductImage[]? images?;
    # The date and time (ISO 8601 format) when the product was created.
    string? created_at?;
    # A unique human-friendly string for the product. Automatically generated from the product's title. Used by the Liquid templating language to refer to objects.
    string? 'handle?;
    # An array of product variants, each representing a different version of the product. The position property is read-only. The position of variants is indicated by the order in which they are listed.
    ProductVariant[]? variants?;
    # The name of the product.
    string? title?;
    # A string of comma-separated tags that are used for filtering and search. A product can have up to 250 tags. Each tag can have up to 255 characters.
    string? tags?;
    # Whether the product is published to the Point of Sale channel.
    string? published_scope?;
    # A categorization for the product used for filtering and searching products.
    string? product_type?;
    # The suffix of the Liquid template used for the product page. If this property is specified, then the product page uses a template called "product.suffix.liquid", where "suffix" is the value of this property. If this property is "" or null, then the product page uses the default template "product.liquid". (default is null)
    string? template_suffix?;
    # The date and time (ISO 8601 format) when the product was last modified. A product's updated_at value can change for different reasons. For example, if an order is placed for a product that has inventory tracking set up, then the inventory adjustment is counted as an update.
    string? updated_at?;
    # The name of the product's vendor.
    string? vendor?;
    # Admin GraphQL API ID
    string? admin_graphql_api_id?;
    # The custom product properties. For example, Size, Color, and Material. Each product can have up to 3 options and each option value can be up to 255 characters. Product variants are made of up combinations of option values. Options cannot be created without values. To create new options, a variant with an associated option value also needs to be created.
    ProductOption[]? options?;
    # An unsigned 64-bit integer that's used as a unique identifier for the product. Each id is unique across the Shopify system. No two products will have the same id, even if they're from different shops.
    int? id?;
    # The date and time (ISO 8601 format) when the product was published. Can be set to null to unpublish the product from the Online Store channel.
    string? published_at?;
    # The status of the product.
    string? status?;
};

public type ProductOption record {
    # Product option product ID
    int? product_id?;
    # Product option values
    string[]? values?;
    # Product option name
    string? name?;
    # Product option ID
    int? id?;
    # Product option position
    int? position?;
};

public type TotalShippingPriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type Receipt record {
    # The authorization code.
    string? authorization?;
    # Whether the fulfillment was a testcase.
    boolean? testcase?;
};

public type CurrentTotalDutiesSet record {
    CurrentTotalDutiesSetObject? current_total_duties_set?;
};

public type PaymentSchedule record {
    # The date and time when the purchase is completed. Returns null initially and updates when the payment is captured.
    string? completed_at?;
    # The amount that is owed according to the payment terms.
    int? amount?;
    # The name of the payment method gateway.
    string? expected_payment_method?;
    # The presentment currency for the payment.
    string? currency?;
    # The date and time when the payment is due. Calculated based on issued_at and due_in_days or a customized fixed date if the type is fixed.
    string? due_at?;
    # The date and time when the payment terms were initiated.
    string? issued_at?;
};

public type ShippingLine record {
    # A reference to the shipping method.
    string? code?;
    # The price of this shipping method in the shop currency. Can't be negative.
    string? price?;
    # The source of the shipping method.
    string? 'source?;
    PriceSet? price_set?;
    # The title of the shipping method.
    string? title?;
    # A reference to the carrier service that provided the rate. Present when the rate was computed by a third-party carrier service.
    string? carrier_identifier?;
    DiscountedPriceSet? discounted_price_set?;
    # The price of the shipping method after line-level discounts have been applied. Doesn't reflect cart-level or order-level discounts.
    string? discounted_price?;
    # A reference to the fulfillment service that is being requested for the shipping method. Present if the shipping method requires processing by a third party fulfillment service; null otherwise.
    string? requested_fulfillment_service_id?;
};

public type Metafield record {
    # The value type. Valid values are string and integer.
    string? value_type;
    # A container for a set of metadata (maximum of 20 characters). Namespaces help distinguish between metadata that you created and metadata created by another individual with a similar namespace.
    string? namespace;
    # Additional information about the metafield.
    string? description?;
    # Information to be stored as metadata.
    string? value;
    # An identifier for the metafield (maximum of 30 characters).
    string? 'key;
};

public type TotalDiscountsSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type LineItem record {
    # The title of the product variant being fulfilled.
    string? variant_title?;
    # The number of items in the fulfillment.
    int? quantity?;
    # The amount available to fulfill. This is the quantity - max (refunded_quantity, fulfilled_quantity) - pending_fulfilled_quantity - open_fulfilled_quantity.
    int? fulfillable_quantity?;
    # The total of any discounts applied to the line item.
    string? total_discount?;
    # The status of an order in terms of the line items being fulfilled. Valid values are fulfilled, null, or partial
    string? fulfillment_status?;
    # The service provider who is doing the fulfillment.
    string? fulfillment_service?;
    # Whether the line item is taxable.
    boolean? taxable?;
    # Whether the line item is a gift card
    boolean? gift_card?;
    # Whether a customer needs to provide a shipping address when placing an order for this product variant.
    boolean? requires_shipping?;
    # A unique identifier for a quantity of items within a single fulfillment. An order can have multiple fulfillment line items.
    int? fulfillment_line_item_id?;
    # The title of the product.
    string? title?;
    # The name of the inventory management system.
    string? variant_inventory_management?;
    # Whether the product exists.
    boolean? product_exists?;
    # The ID of the product variant being fulfilled.
    int? variant_id?;
    # A list of tax line objects, each of which details the title, price, and rate of any taxes applied to the line item.
    TaxLine[]? tax_lines?;
    # The price of the item.
    string? price?;
    # The name of the supplier of the item.
    string? vendor?;
    # The unique numeric identifier for the product in the fulfillment.
    int? product_id?;
    # The name of the product variant.
    string? name?;
    # The ID of the line item within the fulfillment.
    int? id?;
    # The weight of the item in grams.
    int? grams?;
    # The unique identifier of the item in the fulfillment.
    string? sku?;
    # Any additional properties associated with the line item.
    Property[]? properties?;
};

public type DiscountCode record {
    # The value of the discount deducted from the order total. The type field determines how this value is calculated
    string? amount?;
    # The discount code
    string? code?;
    # The type of discount. Can be one of: percentage, shipping, fixed_amount (default) = ['fixed_amount', 'percentage', 'shipping']
    string? 'type?;
};

public type CurrentTotalDutiesSetObject record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type NoteAttribute record {
    # Name
    string? name?;
    # Value
    string? value?;
};

public type Fulfillment record {
    # The date and time when the fulfillment was created. The API returns this value in ISO 8601 format
    string? created_at?;
    Address? origin_address?;
    # A historical record of each item in the fulfillment.
    LineItem[]? line_items?;
    # The name of the tracking company.
    string? tracking_company?;
    # The name of the inventory management service.
    string? variant_inventory_management?;
    # The URLs of tracking pages for the fulfillment.
    string[]? tracking_urls?;
    # The unique identifier of the location that the fulfillment should be processed for. To find the ID of the location, use the Location resource.
    int? location_id?;
    # The date and time (ISO 8601 format) when the fulfillment was last modified.
    string? updated_at?;
    # The type of service used.
    string? 'service?;
    # The uniquely identifying fulfillment name, consisting of two parts separated by a .. The first part represents the order name and the second part represents the fulfillment number. The fulfillment number automatically increments depending on how many fulfillments are in an order (e.g. #1001.1, #1001.2).
    string? name?;
    Receipt? receipt?;
    # The ID for the fulfillment.
    int? id?;
    # A list of tracking numbers, provided by the shipping company.
    string[]? tracking_numbers?;
    # The unique numeric identifier for the order.
    int? order_id?;
    # Whether the customer should be notified. If set to true, then an email will be sent when the fulfillment is created or updated. For orders that were initially created using the API, the default value is false. For all other orders, the default value is true.
    string? notify_customer?;
    # The current shipment status of the fulfillment.
    string? shipment_status?;
    # The status of the fulfillment.
    string? status?;
};

public type OriginalTotalDutiesSetObject record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type SmsMarketingConsent record {
    # The date and time at which the customer consented to receive marketing material by SMS. The customer's consent state reflects the consent record with the most recent last_consent_updated_at date. If no date is provided, then the date and time at which the consent information was sent is used.
    string? consent_updated_at?;
    # The source for whether the customer has consented to receive marketing material by SMS.
    string? consent_collected_from?;
    # The current SMS marketing state for the customer.
    string? state?;
    # The marketing subscription opt-in level, as described by the M3AAWG best practices guidelines, that the customer gave when they consented to receive marketing material by SMS.
    string? opt_in_level?;
};

public type Refund record {
    # An optional note attached to a refund.
    string? note?;
    # A list of refunded line items.
    RefundLineItem[]? refund_line_items?;
    # The unique identifier of the user who performed the refund.
    int? user_id?;
    # A list of order adjustments attached to the refund. Order adjustments are generated to account for refunded shipping costs and differences between calculated and actual refund amounts.
    OrderAdjustment[]? order_adjustments?;
    # The date and time (ISO 8601 format) when the refund was created.
    string? created_at?;
    # The date and time (ISO 8601 format) when the refund was imported. This value can be set to a date in the past when importing from other systems. If no value is provided, then it will be auto-generated as the current time in Shopify. Public apps need to be granted permission by Shopify to import orders with the processed_at timestamp set to a value earlier the created_at timestamp. Private apps can't be granted permission by Shopify.
    string? processed_at?;
    # The unique identifier for the refund.
    int? id?;
};

public type Price record {
    # The variant's price or compare-at price in the presentment currency.
    string? amount?;
    # The three-letter code (ISO 4217 format) for one of the shop's enabled presentment currencies.
    string? currency_code?;
};

public type AmountSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type OrderEvent record {
    # The date and time when the order was canceled. Returns null if the order isn't canceled.
    string? cancelled_at?;
    # The order's status in terms of fulfilled line items.
    string? fulfillment_status?;
    # The sum of all line item prices, discounts, shipping, taxes, and tips in the shop currency. Must be positive.
    string? total_price_usd?;
    CustomerAddress? billing_address?;
    # A list of line item objects, each containing information about an item in the order.
    OrderLineItem[]? line_items?;
    # The presentment currency that was used to display prices to the customer.
    string? presentment_currency?;
    TotalDiscountsSet? total_discounts_set?;
    OriginalTotalDutiesSet? original_total_duties_set?;
    # The ID of the physical location where the order was processed. If you need to reference the location against an order, then use the FulfillmentOrder resource.
    int? location_id?;
    # The source url
    string? source_url?;
    # The URL for the page where the buyer landed when they entered the shop.
    string? landing_site?;
    # The source identifier
    string? source_identifier?;
    # The reference where the customer clicked a link to the shop.
    string? reference?;
    # The order's position in the shop's count of orders. Numbers are sequential and start at 1.
    int? number?;
    # A unique value when referencing the checkout that's associated with the order.
    string? checkout_token?;
    # An array of tax line objects, each of which details a tax applicable to the order. When creating an order through the API, tax lines can be specified on the order or the line items but not both. Tax lines specified on the order are split across the taxable line items in the created order.
    TaxLine[]? tax_lines?;
    # The two or three-letter language code, optionally followed by a region modifier.
    string? customer_locale?;
    # The ID of the order, used for API purposes. This is different from the order_number property, which is the ID used by the shop owner and customer.
    int? id?;
    # The ID of the app that created the order.
    int? app_id?;
    # The price of the order in the shop currency after discounts but before shipping, duties, taxes, and tips.
    string? subtotal_price?;
    # The date and time (ISO 8601 format) when the order was closed. Returns null if the order isn't closed.
    string? closed_at?;
    # The URL pointing to the order status web page, if applicable.
    string? order_status_url?;
    # Whether this is a test order.
    boolean? test?;
    # The device ID
    int? device_id?;
    TotalShippingPriceSet? total_shipping_price_set?;
    SubtotalPriceSet? subtotal_price_set?;
    # The list of payment gateways used for the order.
    string[]? payment_gateway_names?;
    # The sum of all the taxes applied to the order in the shop currency. Must be positive.
    string? total_tax?;
    # Tags attached to the order, formatted as a string of comma-separated values. Tags are additional short descriptors, commonly used for filtering and searching. Each individual tag is limited to 40 characters in length.
    string? tags?;
    # How the payment was processed. It has the following valid values
    string? processing_method?;
    # An array of objects, each of which details a shipping method used.
    ShippingLine[]? shipping_lines?;
    # The ID of the user logged into Shopify POS who processed the order, if applicable.
    int? user_id?;
    # The customer's phone number for receiving SMS notifications.
    string? phone?;
    # Extra information that is added to the order. Appears in the Additional details section of an order details page. Each array entry must contain a hash with name and value keys.
    NoteAttribute[]? note_attributes?;
    # The order name, generated by combining the order_number property with the order prefix and suffix that are set in the merchant's general settings. This is different from the id property, which is the ID of the order used by the API. This field can also be set by the API to be any string value.
    string? name?;
    # A unique value when referencing the cart that's associated with the order.
    string? cart_token?;
    TotalTaxSet? total_tax_set?;
    # The URL for the page where the buyer landed when they entered the shop.
    string? landing_site_ref?;
    # A list of discounts applied to the order.
    DiscountCode[]? discount_codes?;
    # An optional note that a shop owner can attach to the order.
    string? note?;
    # The order 's position in the shop's count of orders starting at 1001. Order numbers are sequential and start at 1001.
    int? order_number?;
    # An ordered list of stacked discount applications.
    DiscountApplication[]? discount_applications?;
    # The autogenerated date and time (ISO 8601 format) when the order was created in Shopify. The value for this property cannot be changed.
    string? created_at?;
    TotalLineItemsPriceSet? total_line_items_price_set?;
    # Whether taxes are included in the order subtotal.
    boolean? taxes_included?;
    # Whether the customer consented to receive email updates from the shop.
    boolean? buyer_accepts_marketing?;
    PaymentTerms? payment_terms?;
    # Confirmation status
    boolean? confirmed?;
    # The sum of all line item weights in grams. The sum is not adjusted as items are removed from the order.
    decimal? total_weight?;
    # The contact email address.
    string? contact_email?;
    # A list of refunds applied to the order. For more information, see the Refund API.
    Refund[]? refunds?;
    # The total discounts applied to the price of the order in the shop currency.
    string? total_discounts?;
    # An array of fulfillments associated with the order. For more information, see the Fulfillment API.
    Fulfillment[]? fulfillments?;
    # The date and time (ISO 8601 format) when the order was last modified. Filtering orders by updated_at is not an effective method for fetching orders because its value can change when no visible fields of an order have been updated. Use the Webhook and Event APIs to subscribe to order events instead.
    string? updated_at?;
    # The website where the customer clicked a link to the shop.
    string? referring_site?;
    # The date and time (ISO 8601 format) when an order was processed. This value is the date that appears on your orders and that's used in the analytic reports. If you're importing orders from an app or another platform, then you can set processed_at to a date and time in the past to match when the original order was created.
    string? processed_at?;
    # The three-letter code (ISO 4217 format) for the shop currency.
    string? currency?;
    CustomerAddress? shipping_address?;
    # The customer's email address.
    string? email?;
    # The IP address of the browser used by the customer when they placed the order. Both IPv4 and IPv6 are supported.
    string? browser_ip?;
    # Where the order originated. Can be set only during order creation, and is not writeable afterwards. Values for Shopify channels are protected and cannot be assigned by other API clients: web, pos, shopify_draft_order, iphone, and android. Orders created via the API can be assigned any other string of your choice. If unspecified, then new orders are assigned the value of your app's ID.
    string? source_name?;
    TotalPriceSet? total_price_set?;
    # The sum of all line item prices, discounts, shipping, taxes, and tips in the shop currency. Must be positive.
    string? total_price?;
    CurrentTotalDutiesSet? current_total_duties_set?;
    # The sum of all line item prices in the shop currency.
    string? total_line_items_price?;
    # The sum of all the tips in the order in the shop currency.
    string? total_tip_received?;
    # A unique value when referencing the order.
    string? token?;
    # The reason why the order was canceled.
    string? cancel_reason?;
    # The status of payments associated with the order. Can only be set when the order is created.
    string? financial_status?;
    # Admin GraphQL API ID.
    string? admin_graphql_api_id?;
    # The payment gateway used.
    string? gateway?;
    Customer? customer?;
};

public type OriginalTotalDutiesSet record {
    OriginalTotalDutiesSetObject? original_total_duties_set?;
};

public type OrderLineItem record {
    # The title of the product variant being fulfilled.
    string? variant_title?;
    Address? origin_location?;
    # The total of any discounts applied to the line item.
    string? total_discount?;
    # The status of an order in terms of the line items being fulfilled. Valid values are fulfilled, null, or partial
    string? fulfillment_status?;
    # Whether the line item is a gift card
    boolean? gift_card?;
    # Whether a customer needs to provide a shipping address when placing an order for this product variant.
    boolean? requires_shipping?;
    # A unique identifier for a quantity of items within a single fulfillment. An order can have multiple fulfillment line items.
    int? fulfillment_line_item_id?;
    TotalDiscountSet? total_discount_set?;
    # The title of the product.
    string? title?;
    # The payment gateway used to tender the tip, such as shopify_payments. Present only on tips
    string? tip_payment_gateway?;
    # Whether the product exists.
    boolean? product_exists?;
    # The ID of the product variant being fulfilled.
    int? variant_id?;
    # A list of tax line objects, each of which details a tax applied to the item.
    TaxLine[]? tax_lines?;
    # The name of the supplier of the item.
    string? vendor?;
    # The price of the item.
    string? price?;
    # The unique numeric identifier for the product in the fulfillment.
    int? product_id?;
    # The ID of the line item within the fulfillment.
    int? id?;
    # The unique identifier of the item in the fulfillment.
    string? sku?;
    # The weight of the item in grams.
    int? grams?;
    # The number of items in the fulfillment.
    int? quantity?;
    # The amount available to fulfill. This is the quantity - max (refunded_quantity, fulfilled_quantity) - pending_fulfilled_quantity - open_fulfilled_quantity.
    int? fulfillable_quantity?;
    # The service provider who is doing the fulfillment.
    string? fulfillment_service?;
    # Whether the line item is taxable.
    boolean? taxable?;
    # The name of the inventory management system.
    string? variant_inventory_management?;
    # An ordered list of amounts allocated by discount applications. Each discount allocation is associated with a particular discount application.
    DiscountAllocations[]? discount_allocations?;
    # The payment method used to tender the tip, such as Visa. Present only on tips.
    string? tip_payment_method?;
    # Admin GraphQL API ID
    string? admin_graphql_api_id?;
    # The name of the product variant.
    string? name?;
    PriceSet? price_set?;
    # Any additional properties associated with the line item.
    Property[]? properties?;
};

public type Option record {
    # Option 3
    string? 'option3?;
    # Option 1
    string? 'option1?;
    # Option 2
    string? 'option2?;
};

public type PresentmentPrice record {
    Price? compare_at_price?;
    Price? price?;
};

public type SubtotalPriceSet record {
    Price? shop_money?;
    Price? presentment_money?;
};

public type DiscountAllocations record {
    # The discount amount allocated to the line in the shop currency.
    string? amount?;
    # The index of the associated discount application in the order's
    int? discount_application_index?;
    AmountSet? amount_set?;
};

public type CustomerAddress record {
    # The postal code (for example, zip, postcode, or Eircode) of the billing address.
    string? zip?;
    # The name of the country of the billing address.
    string? country?;
    # An optional additional field for the street address of the billing address.
    string? 'address2?;
    # The city, town, or village of the billing address.
    string? city?;
    # The street address of the billing address.
    string? 'address1?;
    # The latitude of the billing address.
    string? latitude?;
    # The last name of the person associated with the payment method.
    string? last_name?;
    # The two-letter abbreviation of the region of the billing address.
    string? province_code?;
    # The two-letter code (ISO 3166-1 format) for the country of the billing address.
    string? country_code?;
    # The name of the region (for example, province, state, or prefecture) of the billing address.
    string? province?;
    # The phone number at the billing address.
    string? phone?;
    # The full name of the person associated with the payment method.
    string? name?;
    # The company of the person associated with the billing address.
    string? company?;
    # The first name of the person associated with the payment method.
    string? first_name?;
    # The longitude of the billing address.
    string? longitude?;
};

public type GenericDataType OrderEvent|CustomerEvent|ProductEvent|FulfillmentEvent;
