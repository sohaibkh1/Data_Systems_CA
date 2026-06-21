-- DDL SECTION: create database, tables, constraints and indexes

DROP DATABASE IF EXISTS farm_sustainability;
CREATE DATABASE farm_sustainability;
USE farm_sustainability;

CREATE TABLE Farm (
    farm_id INT NOT NULL,
    farm_location VARCHAR(100) NOT NULL,

    CONSTRAINT pk_farm PRIMARY KEY (farm_id)
);

CREATE TABLE Crop (
    crop_id INT NOT NULL,
    crop_name VARCHAR(50) NOT NULL,

    CONSTRAINT pk_crop PRIMARY KEY (crop_id)
);

CREATE TABLE SoilHealth (
    soil_id INT NOT NULL,
    ph_level DECIMAL(3,1) NOT NULL,
    nitrogen_level INT NOT NULL,
    phosphorus_level INT NOT NULL,
    potassium_level INT NOT NULL,

    CONSTRAINT pk_soilhealth PRIMARY KEY (soil_id),
    CONSTRAINT chk_soil_ph CHECK (ph_level BETWEEN 0 AND 14),
    CONSTRAINT chk_soil_nitrogen CHECK (nitrogen_level >= 0),
    CONSTRAINT chk_soil_phosphorus CHECK (phosphorus_level >= 0),
    CONSTRAINT chk_soil_potassium CHECK (potassium_level >= 0)
);

CREATE TABLE ResourceType (
    resource_id INT NOT NULL,
    resource_type VARCHAR(50) NOT NULL,

    CONSTRAINT pk_resourcetype PRIMARY KEY (resource_id),
    CONSTRAINT uq_resourcetype_type UNIQUE (resource_type)
);

CREATE TABLE SustainabilityInitiative (
    initiative_id INT NOT NULL,
    initiative_description VARCHAR(150) NOT NULL,
    date_initiated DATE NOT NULL,
    expected_impact VARCHAR(150) NOT NULL,

    CONSTRAINT pk_sustainabilityinitiative PRIMARY KEY (initiative_id)
);

CREATE TABLE FarmCrop (
    farm_crop_id INT NOT NULL AUTO_INCREMENT,
    farm_id INT NOT NULL,
    crop_id INT NOT NULL,
    soil_id INT NOT NULL,
    initiative_id INT NOT NULL,
    planting_date DATE NOT NULL,
    harvest_date DATE NOT NULL,
    crop_yield INT NOT NULL,
    environmental_impact_score INT NOT NULL,
    water_source VARCHAR(50) NOT NULL,
    labour_hours INT NOT NULL,

    CONSTRAINT pk_farmcrop PRIMARY KEY (farm_crop_id),
    CONSTRAINT uq_farmcrop_farm_crop_planting UNIQUE (farm_id, crop_id, planting_date),
    CONSTRAINT chk_farmcrop_yield CHECK (crop_yield >= 0),
    CONSTRAINT chk_farmcrop_impact CHECK (environmental_impact_score BETWEEN 1 AND 5),
    CONSTRAINT chk_farmcrop_labour CHECK (labour_hours >= 0),
    CONSTRAINT chk_farmcrop_dates CHECK (harvest_date >= planting_date)
);

CREATE TABLE ResourceApplication (
    application_id INT NOT NULL AUTO_INCREMENT,
    farm_crop_id INT NOT NULL,
    resource_id INT NOT NULL,
    resource_quantity DECIMAL(12,2) NOT NULL,
    date_of_application DATE NOT NULL,

    CONSTRAINT pk_resourceapplication PRIMARY KEY (application_id),
    CONSTRAINT chk_resource_quantity CHECK (resource_quantity >= 0)
);

CREATE INDEX idx_farmcrop_farm_crop
ON FarmCrop(farm_id, crop_id);

CREATE INDEX idx_farmcrop_initiative
ON FarmCrop(initiative_id);

CREATE INDEX idx_resourceapplication_resource_date
ON ResourceApplication(resource_id, date_of_application);

CREATE INDEX idx_resourceapplication_farmcrop
ON ResourceApplication(farm_crop_id);

ALTER TABLE FarmCrop
    ADD CONSTRAINT fk_farmcrop_farm
        FOREIGN KEY (farm_id)
        REFERENCES Farm(farm_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_farmcrop_crop
        FOREIGN KEY (crop_id)
        REFERENCES Crop(crop_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_farmcrop_soil
        FOREIGN KEY (soil_id)
        REFERENCES SoilHealth(soil_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_farmcrop_initiative
        FOREIGN KEY (initiative_id)
        REFERENCES SustainabilityInitiative(initiative_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;

ALTER TABLE ResourceApplication
    ADD CONSTRAINT fk_resourceapplication_farmcrop
        FOREIGN KEY (farm_crop_id)
        REFERENCES FarmCrop(farm_crop_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    ADD CONSTRAINT fk_resourceapplication_resourcetype
        FOREIGN KEY (resource_id)
        REFERENCES ResourceType(resource_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;

-- DML SECTION: insert supplied data

INSERT INTO Farm (farm_id, farm_location) VALUES
(1, 'South Farm, Kent'),
(2, 'Green Acres, Essex'),
(3, 'Sunny Fields, Hampshire'),
(4, 'Hilltop Farm, Yorkshire'),
(5, 'Riverbend Farm, Cornwall');

INSERT INTO Crop (crop_id, crop_name) VALUES
(101, 'Wheat'),
(102, 'Barley'),
(201, 'Corn'),
(202, 'Soybeans'),
(301, 'Potatoes'),
(302, 'Carrots'),
(401, 'Apples'),
(402, 'Pears'),
(501, 'Tomatoes'),
(502, 'Lettuce');

INSERT INTO SoilHealth (
    soil_id,
    ph_level,
    nitrogen_level,
    phosphorus_level,
    potassium_level
) VALUES
(1, 6.5, 50, 20, 180),
(2, 6.8, 40, 25, 160),
(3, 6.2, 30, 15, 150),
(4, 6.4, 45, 22, 175),
(5, 6.7, 55, 28, 200);

INSERT INTO ResourceType (resource_id, resource_type) VALUES
(1, 'Water'),
(2, 'Fertilizer'),
(3, 'Energy');

INSERT INTO SustainabilityInitiative (
    initiative_id,
    initiative_description,
    date_initiated,
    expected_impact
) VALUES
(1, 'Organic Farming', '2023-01-01', 'Increase in yield'),
(2, 'Crop Rotation', '2023-02-15', 'Improved soil quality'),
(3, 'Water Conservation', '2023-03-01', 'Reduced water usage'),
(4, 'Soil Health Improvement', '2023-01-20', 'Enhanced nutrient retention'),
(5, 'Pesticide Reduction', '2023-02-10', 'Less chemical runoff');

INSERT INTO FarmCrop (
    farm_id,
    crop_id,
    soil_id,
    initiative_id,
    planting_date,
    harvest_date,
    crop_yield,
    environmental_impact_score,
    water_source,
    labour_hours
) VALUES
(1, 101, 1, 1, '2023-03-15', '2023-08-15', 3000, 4, 'River', 150),
(1, 102, 1, 1, '2023-03-16', '2023-08-20', 2800, 4, 'River', 120),
(2, 201, 2, 2, '2023-04-10', '2023-09-15', 1500, 3, 'Borehole', 200),
(2, 202, 2, 2, '2023-04-11', '2023-09-20', 1200, 3, 'Borehole', 180),
(3, 301, 3, 3, '2023-03-20', '2023-07-15', 2000, 5, 'Rainwater', 160),
(3, 302, 3, 3, '2023-03-21', '2023-07-20', 2200, 5, 'Rainwater', 170),
(4, 401, 4, 4, '2023-04-05', '2023-09-10', 1800, 2, 'Well', 140),
(4, 402, 4, 4, '2023-04-06', '2023-09-15', 1600, 2, 'Well', 130),
(5, 501, 5, 5, '2023-03-25', '2023-08-10', 2500, 4, 'River', 190),
(5, 502, 5, 5, '2023-03-26', '2023-08-15', 2400, 4, 'River', 175);

INSERT INTO ResourceApplication (
    farm_crop_id,
    resource_id,
    resource_quantity,
    date_of_application
) VALUES
(1, 1, 1000.00, '2023-03-10'),
(1, 3, 360000.00, '2023-05-30'),
(2, 2, 200.00, '2023-03-12'),
(2, 3, 280000.00, '2023-06-02'),

(3, 1, 800.00, '2023-04-05'),
(3, 3, 180000.00, '2023-09-24'),
(4, 2, 150.00, '2023-04-06'),
(4, 3, 144000.00, '2023-10-12'),

(5, 1, 1200.00, '2023-03-18'),
(5, 3, 240000.00, '2023-05-17'),
(6, 2, 300.00, '2023-03-19'),
(6, 3, 264000.00, '2023-05-20'),

(7, 1, 900.00, '2023-04-02'),
(7, 3, 216000.00, '2023-07-22'),
(8, 2, 250.00, '2023-04-03'),
(8, 3, 192000.00, '2023-07-25'),

(9, 3, 300000.00, '2023-07-01'),
(9, 1, 1100.00, '2023-03-22'),
(10, 3, 288000.00, '2023-06-05'),
(10, 2, 180.00, '2023-03-24');

-- DDL object used to reuse the joined sustainability profile query.
CREATE OR REPLACE VIEW vw_farm_sustainability_profile AS
SELECT
    f.farm_id,
    f.farm_location,
    c.crop_id,
    c.crop_name,
    fc.planting_date,
    fc.harvest_date,
    s.soil_id,
    s.ph_level,
    s.nitrogen_level,
    s.phosphorus_level,
    s.potassium_level,
    si.initiative_id,
    si.initiative_description,
    si.date_initiated,
    si.expected_impact,
    rt.resource_type,
    ra.resource_quantity,
    ra.date_of_application,
    fc.crop_yield,
    fc.environmental_impact_score,
    fc.water_source,
    fc.labour_hours
FROM ResourceApplication ra
JOIN FarmCrop fc ON ra.farm_crop_id = fc.farm_crop_id
JOIN Farm f ON fc.farm_id = f.farm_id
JOIN Crop c ON fc.crop_id = c.crop_id
JOIN SoilHealth s ON fc.soil_id = s.soil_id
JOIN SustainabilityInitiative si ON fc.initiative_id = si.initiative_id
JOIN ResourceType rt ON ra.resource_id = rt.resource_id;

-- DML SECTION: validation and analysis queries

-- Check all tables.
SELECT * FROM Farm;
SELECT * FROM Crop;
SELECT * FROM SoilHealth;
SELECT * FROM ResourceType;
SELECT * FROM SustainabilityInitiative;
SELECT * FROM FarmCrop;
SELECT * FROM ResourceApplication;

-- Check expected row counts from the supplied CSV.
SELECT 'Farm' AS table_name, COUNT(*) AS row_count FROM Farm
UNION ALL
SELECT 'Crop', COUNT(*) FROM Crop
UNION ALL
SELECT 'SoilHealth', COUNT(*) FROM SoilHealth
UNION ALL
SELECT 'ResourceType', COUNT(*) FROM ResourceType
UNION ALL
SELECT 'SustainabilityInitiative', COUNT(*) FROM SustainabilityInitiative
UNION ALL
SELECT 'FarmCrop', COUNT(*) FROM FarmCrop
UNION ALL
SELECT 'ResourceApplication', COUNT(*) FROM ResourceApplication;

-- Check joined farm, crop, soil, initiative, resource and impact data.
SELECT
    f.farm_location,
    c.crop_name,
    fc.planting_date,
    fc.harvest_date,
    s.ph_level,
    s.nitrogen_level,
    s.phosphorus_level,
    s.potassium_level,
    si.initiative_description,
    rt.resource_type,
    ra.resource_quantity,
    ra.date_of_application,
    fc.crop_yield,
    fc.environmental_impact_score,
    fc.water_source,
    fc.labour_hours
FROM ResourceApplication ra
JOIN FarmCrop fc ON ra.farm_crop_id = fc.farm_crop_id
JOIN Farm f ON fc.farm_id = f.farm_id
JOIN Crop c ON fc.crop_id = c.crop_id
JOIN SoilHealth s ON fc.soil_id = s.soil_id
JOIN SustainabilityInitiative si ON fc.initiative_id = si.initiative_id
JOIN ResourceType rt ON ra.resource_id = rt.resource_id;

-- Check the reusable joined view. This should return 20 rows.
SELECT * FROM vw_farm_sustainability_profile;

-- Check energy usage records only. This should return 10 rows.
SELECT
    f.farm_location,
    c.crop_name,
    ra.resource_quantity AS energy_quantity,
    ra.date_of_application,
    fc.crop_yield,
    fc.environmental_impact_score
FROM ResourceApplication ra
JOIN FarmCrop fc ON ra.farm_crop_id = fc.farm_crop_id
JOIN Farm f ON fc.farm_id = f.farm_id
JOIN Crop c ON fc.crop_id = c.crop_id
JOIN ResourceType rt ON ra.resource_id = rt.resource_id
WHERE rt.resource_type = 'Energy';

-- Validate energy count and total energy quantity. Total Energy should be 2,464,000.
SELECT
    COUNT(*) AS energy_rows,
    SUM(ra.resource_quantity) AS total_energy_quantity
FROM ResourceApplication ra
JOIN ResourceType rt ON ra.resource_id = rt.resource_id
WHERE rt.resource_type = 'Energy';

-- Show Energy applications recorded after the harvest date. This should return 2 rows.
SELECT
    f.farm_location,
    c.crop_name,
    rt.resource_type,
    ra.resource_quantity,
    ra.date_of_application,
    fc.harvest_date
FROM ResourceApplication ra
JOIN FarmCrop fc ON ra.farm_crop_id = fc.farm_crop_id
JOIN Farm f ON fc.farm_id = f.farm_id
JOIN Crop c ON fc.crop_id = c.crop_id
JOIN ResourceType rt ON ra.resource_id = rt.resource_id
WHERE ra.date_of_application > fc.harvest_date
  AND rt.resource_type = 'Energy';

-- Sustainability analysis: total energy use and average environmental score by farm.
SELECT
    f.farm_location,
    COALESCE(e.total_energy_quantity, 0) AS total_energy_quantity,
    s.average_environmental_score
FROM Farm f
LEFT JOIN (
    SELECT
        fc.farm_id,
        SUM(ra.resource_quantity) AS total_energy_quantity
    FROM FarmCrop fc
    JOIN ResourceApplication ra
        ON fc.farm_crop_id = ra.farm_crop_id
    JOIN ResourceType rt
        ON ra.resource_id = rt.resource_id
    WHERE rt.resource_type = 'Energy'
    GROUP BY fc.farm_id
) e ON f.farm_id = e.farm_id
LEFT JOIN (
    SELECT
        farm_id,
        ROUND(AVG(environmental_impact_score), 2)
            AS average_environmental_score
    FROM FarmCrop
    GROUP BY farm_id
) s ON f.farm_id = s.farm_id
ORDER BY total_energy_quantity DESC;

-- Analysis query using GROUP BY and HAVING:
-- farms with total Energy use above 500,000.
SELECT
    f.farm_location,
    SUM(ra.resource_quantity) AS total_energy_quantity
FROM Farm f
JOIN FarmCrop fc ON f.farm_id = fc.farm_id
JOIN ResourceApplication ra ON fc.farm_crop_id = ra.farm_crop_id
JOIN ResourceType rt ON ra.resource_id = rt.resource_id
WHERE rt.resource_type = 'Energy'
GROUP BY f.farm_id, f.farm_location
HAVING SUM(ra.resource_quantity) > 500000
ORDER BY total_energy_quantity DESC;

-- DDL checks to show named constraints, referential actions and indexes.
SHOW CREATE TABLE FarmCrop;
SHOW CREATE TABLE ResourceApplication;
SHOW INDEXES FROM FarmCrop;
SHOW INDEXES FROM ResourceApplication;
