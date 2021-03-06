--    Openbravo POS is a point of sales application designed for touch screens.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is modified as part of fastfood branch of Openbravo POS. 2008
--    Copyright (C) Open Sistemas de Información Internet, S.L.
--    http://www.opensistemas.com
--    e-mail: imasd@opensistemas.com
--
--    This program is free software; you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation; either version 2 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program; if not, write to the Free Software
--    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

-- Database upgrade script for POSTGRESQL
-- v2.10 - v2.10 fastfood


INSERT INTO CATEGORIES(ID, NAME, PARENTID, IMAGE) VALUES ('0', 'Composiciones', null, null);
INSERT INTO CATEGORIES(ID, NAME, PARENTID, IMAGE) VALUES ('-1', 'BOM', null, null);
INSERT INTO TAXES(ID, NAME, RATE) VALUES ('-1', 'NOTAX', 0.0);

CREATE TABLE PRODUCTS_MAT (
    PRODUCT VARCHAR NOT NULL,
    MATERIAL VARCHAR NOT NULL,
    AMOUNT DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (PRODUCT, MATERIAL),
    CONSTRAINT PROD_MAT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PROD_MAT_FK_2 FOREIGN KEY (MATERIAL) REFERENCES PRODUCTS(ID) 
);

CREATE TABLE SUBGROUPS (
    ID VARCHAR NOT NULL,
    COMPOSITION VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    IMAGE BYTEA,
    PRIMARY KEY(ID),
    CONSTRAINT SUBGROUPS_FK_1 FOREIGN KEY (COMPOSITION) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE SUBGROUPS_PROD (
    SUBGROUP VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    PRIMARY KEY (SUBGROUP, PRODUCT),
    CONSTRAINT SUBGROUPS_PROD_FK_1 FOREIGN KEY (SUBGROUP) REFERENCES SUBGROUPS(ID) ON DELETE CASCADE,
    CONSTRAINT SUBGROUPS_PROD_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE TARIFFAREAS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    TARIFFORDER INTEGER DEFAULT 0,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX TARIFFAREAS_NAME_INX ON TARIFFAREAS(NAME);

CREATE TABLE TARIFFAREAS_PROD (
    TARIFFID VARCHAR NOT NULL,
    PRODUCTID VARCHAR NOT NULL,
    PRICESELL DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (TARIFFID, PRODUCTID),
    CONSTRAINT TARIFFAREAS_PROD_FK_1 FOREIGN KEY (TARIFFID) REFERENCES TARIFFAREAS(ID) ON DELETE CASCADE,
    CONSTRAINT TARIFFAREAS_PROD_FK_2 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE DISCOUNTS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    QUANTITY DOUBLE PRECISION NOT NULL,
    PERCENTAGE BOOLEAN NOT NULL,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX DISCOUNTS_NAME_INX ON DISCOUNTS(NAME);

CREATE TABLE UNITS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    SYMBOL VARCHAR NOT NULL,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX UNITS_NMAE_INX ON UNITS(NAME);

CREATE TABLE MATERIALS_UNITS (
    MATERIAL VARCHAR NOT NULL,
    UNIT VARCHAR NOT NULL,
    AMOUNT DOUBLE PRECISION NOT NULL,
    PRICEBUY DOUBLE PRECISION NOT NULL,
    PRIMARY KEY(MATERIAL, UNIT),
    CONSTRAINT MAT_UNIT_FK_1 FOREIGN KEY (MATERIAL) REFERENCES PRODUCTS(ID),
    CONSTRAINT MAT_UNIT_FK_2 FOREIGN KEY (UNIT) REFERENCES UNITS(ID)
);

ALTER TABLE TICKETS ADD COLUMN DISCOUNTNAME VARCHAR;
ALTER TABLE TICKETS ADD COLUMN DISCOUNTVALUE VARCHAR;
ALTER TABLE TICKETS ADD COLUMN TARIFFAREA VARCHAR DEFAULT NULL;
ALTER TABLE TICKETS ADD CONSTRAINT TICKETS_TARIFFAREA FOREIGN KEY (TARIFFAREA) REFERENCES TARIFFAREAS(ID);

ALTER TABLE TICKETS ADD COLUMN ISDISCOUNT BOOLEAN;

