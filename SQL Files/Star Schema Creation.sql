-- location
CREATE TABLE location_dim (
    ship_state_id INT PRIMARY KEY,
    ship_state VARCHAR(100),
    ship_city VARCHAR(100),
    ship_postal_code VARCHAR(20),
    ship_country VARCHAR(100)
);


-- fulfillment
CREATE TABLE fulfillment_dim (
    fulfillment_id INT PRIMARY KEY,
    fulfillment VARCHAR(100),
    fulfillment_by VARCHAR(100),
    ship_service_level VARCHAR(50),
    courier_status VARCHAR(50)
);


-- sales_channel
CREATE TABLE sales_channel_dim (
    sales_channel_id INT PRIMARY KEY,
    sales_channel VARCHAR(100)
);


-- product
CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    sku VARCHAR(100),
    style VARCHAR(100),
    category VARCHAR(100),
    size VARCHAR(50),
    asin VARCHAR(100)
);


-- date
CREATE TABLE date_dim (
    date_id INT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT,
    weekday VARCHAR(20)
);


-- orders_fact
CREATE TABLE orders_fact (
    order_id varchar(50) PRIMARY KEY,
    date_id INT,
    product_id INT,
    fulfillment_id INT,
    sales_channel_id INT,
    ship_state_id INT,
    quantity INT,
    amount DECIMAL(10,2),
    currency VARCHAR(10),
    status VARCHAR(50),

    FOREIGN KEY (date_id) REFERENCES date_dim(date_id),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (fulfillment_id) REFERENCES fulfillment_dim(fulfillment_id),
    FOREIGN KEY (sales_channel_id) REFERENCES sales_channel_dim(sales_channel_id),
    FOREIGN KEY (ship_state_id) REFERENCES location_dim(ship_state_id)
);

