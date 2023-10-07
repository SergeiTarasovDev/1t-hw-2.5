CREATE TABLE IF NOT EXISTS public.products
(
    product_id  	serial primary key,
    product_name	varchar(150),
    price   		numeric
);

CREATE TABLE IF NOT EXISTS public.shops
(
    shop_id  	    serial primary key,
    shop_name	    varchar(150)
);

CREATE TABLE IF NOT EXISTS public.shop_dns
(
    product_id	    bigint,
    date		    date,
    sales_cnt		int,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS public.shop_mvideo
(
    product_id	    bigint,
    date		    date,
    sales_cnt		int,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS public.shop_sitilink
(
    product_id	    bigint,
    date		    date,
    sales_cnt		int,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id)
);


CREATE TABLE IF NOT EXISTS public.sales
(
    shop_id			bigint,
    product_id	    bigint,
    date	    	date,
    CONSTRAINT fk_shop FOREIGN KEY (shop_id) REFERENCES shops (shop_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS public.plan
(
    shop_id    bigint,
    product_id bigint,
    plan_date  date,
    plan_cnt   int,
    CONSTRAINT fk_shop FOREIGN KEY (shop_id) REFERENCES shops (shop_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products (product_id)
);

