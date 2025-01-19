CREATE TABLE geolocation (
    zipCodeId varchar(255) NOT NULL,
    lat varchar(255),
    lng varchar(255),
    city varchar(255),
    geoState varchar(255),
    validFrom datetime,
    validTo datetime,
    isCurrent int
)

CREATE TABLE customers (
    customerId varchar(255) NOT NULL,
    uniqueCustomerId varchar(255) NOT NULL,
    zipCodeId varchar(255) NOT NULL,
    validFrom datetime,
    validTo datetime,
    isCurrent int
)

CREATE TABLE orders (
    orderId varchar(255) NOT NULL,
    customerId varchar(255) NOT NULL,
    orderStatus varchar(255),
    orderPurchaseDate datetime,
    orderDeliveredCarrierDate datetime,
    orderDeliveredCustomerDate datetime,
    orderEstimatedDeliveryDate datetime
)

CREATE TABLE products (
    productId varchar(255) NOT NULL,
    categoryNameBRA varchar(255),
    categoryNameENG varchar(255),
    productWeightG float,
    productLenghtCM float,
    productHeightCM float,
    productWidthCM float,
    validFrom datetime,
    validTo datetime,
    isCurrent int
)

CREATE TABLE sellers (
    sellerId varchar(255) NOT NULL,
    zipCodeId varchar(255) NOT NULL,
    validFrom datetime,
    validTo datetime,
    isCurrent int
)

CREATE TABLE orderItems (
    orderId varchar(255) NOT NULL,
    productId varchar(255) NOT NULL,
    sellerId varchar(255) NOT NULL,
    itemCount int NOT NULL,
    shippingLimitDate datetime,
    price float NOT NULL,
    freightValue float NOT NULL
)

CREATE TABLE orderPayments (
    orderId varchar(255) NOT NULL,
    paymentSeq int,
    paymentType varchar(255),
    paymentInstallments int,
    paymentValue float
)

load_filter_data(table_name='customers',
                 df=customers,
                 key_columns=['customerId'])

load_filter_data(table_name='geolocation',
                 df=geolocation,
                 key_columns=['zipCodeId'])
load_filter_data(table_name='sellers',
                 df=sellers,
                 key_columns=['sellerId'])

load_filter_data(table_name='products',
                 df=products,
                 key_columns=['productId'])