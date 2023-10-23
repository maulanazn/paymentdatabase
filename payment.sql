CREATE TABLE CUSTOMER(
    CUST_ID BIGINT UNIQUE NOT NULL PRIMARY KEY,
    CUST_FIRSTNAME VARCHAR(30) NOT NULL,
    CUST_LASTNAME VARCHAR(30),
    CUST_BIRTHDATE DATE,
    CUST_GENDER CHAR(1) NOT NULL,
    CUST_ADDRESS VARCHAR(50),
    CUST_CITY VARCHAR(20),
    CUST_POSTCODE CHAR(5)
);

CREATE TABLE ACCOUNT(
    ACC_NUMBER CHAR(13) UNIQUE NOT NULL PRIMARY KEY,
    ACC_OWNER BIGINT NOT NULL,
    ACC_DATE_CREATED DATE NOT NULL DEFAULT NOW(),
    ACC_BALANCE DECIMAL(10, 0) NOT NULL
);

ALTER TABLE ACCOUNT 
ADD FOREIGN KEY(ACC_OWNER) 
REFERENCES CUSTOMER(CUST_ID) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE TRANSACTION_TRANSFER(
    TRS_ID BIGINT NOT NULL PRIMARY KEY,
    TRS_TO_ACCOUNT CHAR(13) NOT NULL,
    TRS_STATUS CHAR(1) NOT NULL
);

ALTER TABLE TRANSACTION_TRANSFER 
ADD FOREIGN KEY(TRS_TO_ACCOUNT) 
REFERENCES ACCOUNT(ACC_NUMBER) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE TRANSACTION_TRANSFER 
ADD FOREIGN KEY(TRS_ID) 
REFERENCES TRANSACTION(TRS_ID) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE TRANSACTION(
    TRS_ID BIGINT UNIQUE NOT NULL PRIMARY KEY,
    TRS_FROM_ACCOUNT CHAR(13) NOT NULL,
    TRS_DATE DATE NOT NULL DEFAULT NOW(),
    TRS_AMOUNT DECIMAL(10, 0) NOT NULL,
    TRS_TYPE CHAR(2) NOT NULL
);

ALTER TABLE TRANSACTION 
ADD FOREIGN KEY(TRS_FROM_ACCOUNT) 
REFERENCES ACCOUNT(ACC_NUMBER) ON UPDATE CASCADE ON DELETE CASCADE;

-- Customer acc number and total of his account balance;
SELECT COUNT(account.acc_number) AS account_number, SUM(account.acc_balance) AS account_total_balance, CONCAT(customer.cust_firstname, ' ', customer.cust_lastname) AS name FROM account JOIN customer ON account.acc_owner = customer.cust_id WHERE account.acc_owner = 2 GROUP BY customer.cust_id;

-- Customers acc number and total of all account balance;
SELECT COUNT(account.acc_number) AS account_number, SUM(account.acc_balance) AS account_total_balance, CONCAT(customer.cust_firstname, ' ', customer.cust_lastname) AS name FROM account JOIN customer ON account.acc_owner = customer.cust_id GROUP BY customer.cust_id;

-- All transaction that made by all customer sorted by acc_number and trs_date;
SELECT transaction.trs_from_account AS my_account_number, transaction.trs_amount AS transfer_amount, transaction.trs_type AS transfer_type, transaction.trs_date AS transfer_date FROM transaction JOIN account ON transaction.trs_from_account = account.acc_number;

-- ALl transaction that made by john michael sorted by acc_number and trs_date;
SELECT transaction.trs_from_account AS my_account_number, transaction.trs_amount AS transfer_amount, transaction.trs_type AS transfer_type, transaction.trs_date AS transfer_date FROM transaction JOIN account ON transaction.trs_from_account = account.acc_number WHERE transaction.trs_from_account = '1202040-C' ORDER BY transaction.trs_from_account ASC;

-- ADDING customer data;
INSERT INTO customer 
    (CUST_ID, CUST_FIRSTNAME, CUST_LASTNAME, CUST_BIRTHDATE, CUST_GENDER, CUST_ADDRESS, CUST_CITY, CUST_POSTCODE) 
VALUES 
    (2, 'Fatih', 'Kurniawan', '19-08-2004', '1', 'West Boyolali', 'Boyolali', '2321');
-- ADDING john michael
INSERT INTO customer 
    (CUST_ID, CUST_FIRSTNAME, CUST_LASTNAME, CUST_BIRTHDATE, CUST_GENDER, CUST_ADDRESS, CUST_CITY, CUST_POSTCODE) 
VALUES 
    (3, 'John', 'Michael', '19-08-1987', '1', 'West Coast', 'Nevada', '12');

-- ADDING new customer account;
INSERT INTO ACCOUNT
    (ACC_NUMBER, ACC_OWNER, ACC_DATE_CREATED, ACC_BALANCE)
VALUES
    ('456789-B', 2, '20-01-2017', 10000000);

-- ADDING new customer account from john;
INSERT INTO ACCOUNT
    (ACC_NUMBER, ACC_OWNER, ACC_DATE_CREATED, ACC_BALANCE)
VALUES
    ('1202040-C', 3, '20-01-2020', 100000000);

-- Make Transaction;
INSERT INTO transaction
    (TRS_ID, TRS_FROM_ACCOUNT, TRS_DATE, TRS_AMOUNT, TRS_TYPE)
VALUES
    (81, '1202040-C', '12-12-2021', 9000, 'DB');

-- Make transaction;
INSERT INTO transaction
    (TRS_ID, TRS_FROM_ACCOUNT, TRS_DATE, TRS_AMOUNT, TRS_TYPE)
VALUES
    (90, '1202010-C', '12-12-2016', 200000, 'TF');

-- TRANSACTION result;
INSERT INTO TRANSACTION_TRANSFER
    (TRS_ID, TRS_TO_ACCOUNT, TRS_STATUS)
VALUES
    (81, '1272023-B', 1);

-- TRANSACTION result;
INSERT INTO TRANSACTION_TRANSFER
    (TRS_ID, TRS_TO_ACCOUNT, TRS_STATUS)
VALUES
    (90, '1272023-B', 1);