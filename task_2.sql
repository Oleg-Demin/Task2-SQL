-- CREATE DATABASE IF NOT EXISTS task_2;

-- DROP TABLE IF EXISTS instance;
-- DROP TABLE IF EXISTS product;
-- DROP TABLE IF EXISTS storage;

-- Необходимо создать дополнительную сущнсть (instance) для организации связи многие ко многим между.

CREATE TABLE IF NOT EXISTS storage (
  id INT PRIMARY KEY AUTO_INCREMENT,
  city VARCHAR(100) NOT NULL,
  address VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS product (
  sku INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(15, 2) NOT NULL,
  description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS instance (
  productSKU int,
  storageID int,
  FOREIGN KEY (productSKU) REFERENCES product (sku),
  FOREIGN KEY (storageID) REFERENCES storage (id)
);

-- В целях сокращения написания работы, вместо ручного заполнения уникальных значений: артикулов товаров (product.id) и складских номеров (storage.id), было использовано заполнение с помощью автоматически создаваемых инкрементов.

INSERT INTO storage (city, address) VALUES
('Казань', 'ул. Пушкина дом 1а кв. 6'),
('Казань', 'ул. Дубравная дом 2в кв. 7'),
('Москва', 'ул. Габдулы дом 123 кв. 18'),
('Нижний Новгород', 'ул. Машинная дом 34 кв. 12');

INSERT INTO product (name, price, description) VALUES
('DVD-плеер BBK DVP 753HD', 800, 'DVD-плеер'),
('DVD-плеер BBK DVP 953HD', 900.5, 'DVD-плеер'),
('DVD-плеер BBK DMP1024HD (+ 3 DVD диска)', 1200.45, 'DVD-плеер'),
('Магнитола HYUNDAI H-1404', 2500, 'Мультимедиа'),
('Blu-ray плеер PHILIPS DVP3700 (51)', 1000.5, 'Blu-Ray плеер'),
('Плазменный телевизор LG 50PZ250 (3D)', 5000, 'Плазменный телевизор диагональю до 45 дюймов'),
('Плазменный телевизор Samsung PS51D450', 6000, 'Плазменный телевизор диагональю до 45 дюймов'),
('Плазменный телевизор LG 42PT250', 7000, 'Плазменный телевизор диагональю более 40 дюймов'),
('Телевизор-ЖК LG 26LK330', 12000, 'Телевизор-ЖК диагональю более 40 дюймов'),
('Телевизор-ЖК Fusion FLTV-16W7', 14000, 'Телевизор-ЖК диагональю до 45 дюймов'),
('Телевизор-ЖК Samsung LE32D403', 20000, 'Телевизор-ЖК диагональю до 45 дюймов'),
('Телевизор Erisson 1435', 18000.75, 'Телевизор-ЖК диагональю до 45 дюймов');

-- DELETE FROM instance;
INSERT INTO instance (storageID, productSKU) VALUES
(1, 1),
(1, 1),
(1, 2),
(1, 2),
(1, 4),
(1, 4),
(1, 4),
(1, 5),
(2, 5),
(2, 5),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(3, 9),
(3, 9),
(3, 9),
(3, 10),
(3, 10),
(3, 10),
(3, 11),
(3, 12),
(4, 12),
(4, 1),
(4, 2),
(4, 2),
(4, 4),
(4, 5),
(4, 6),
(4, 8),
(4, 9),
(4, 9);

-- 1) Возвращают список складов на которых есть товар с артикулом Var
SET @var = 5;
SELECT DISTINCT stg.* FROM instance as ins
  JOIN storage AS stg ON (ins.storageID = stg.id)
  JOIN product AS prd ON (ins.productSKU = prd.sku)
  WHERE prd.sku = @var;

-- 2) Возвращают количество каждого товара (с одним артикулом) на складе Var
SET @var = 1;
SELECT prd.sku, count(ins.productSKU) as count FROM product AS prd
  LEFT JOIN instance AS ins ON (ins.productSKU = prd.sku)
  WHERE ins.storageID = @var
  GROUP BY prd.sku;

--    второй вариант решения

SET @var = 1;
SELECT prd.sku, IFNULL(slc.count, 0) as count FROM product AS prd
  LEFT JOIN (
    SELECT prd.sku, count(ins.productSKU) as count FROM product AS prd
      LEFT JOIN instance AS ins ON (ins.productSKU = prd.sku)
      WHERE ins.storageID = @var
      GROUP BY prd.sku
  ) AS slc on (slc.sku = prd.sku);

-- 3) Возвращают список товаров на складах города Var

SET @var = 'Казань';
SELECT DISTINCT prd.* FROM instance as ins
  JOIN storage AS stg ON (ins.storageID = stg.id)
  JOIN product AS prd ON (ins.productSKU = prd.sku)
  WHERE stg.city = @var;

-- 4) Возвращают склад, на котором больше всего товара с артикулом Var

SET @var = 5;
SELECT stg.* FROM instance as ins
  JOIN storage AS stg ON (ins.storageID = stg.id)
  JOIN product AS prd ON (ins.productSKU = prd.sku)
  WHERE prd.sku = @var
  GROUP BY stg.id
  ORDER BY count(stg.id) DESC
  LIMIT 1;
