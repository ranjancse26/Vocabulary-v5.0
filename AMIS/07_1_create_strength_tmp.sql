--DROP TABLE IF EIXISTS STRENGTH_TMP;
CREATE TABLE STRENGTH_TMP
(
   DRUG_CODE          VARCHAR(255),
   INGREDIENT_CODE    VARCHAR(255),
   INGREDIENT_NAME    VARCHAR(255),
   AMOUNT_VALUE       FLOAT,
   AMOUNT_UNIT        VARCHAR(255),
   NUMERATOR_VALUE    FLOAT,
   NUMERATOR_UNIT     VARCHAR(255),
   DENOMINATOR_VALUE  FLOAT,
   DENOMINATOR_UNIT   VARCHAR(255)
);
