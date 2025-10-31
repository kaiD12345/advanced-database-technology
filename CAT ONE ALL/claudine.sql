Q1. Create the schema with PK/FK and domain constraints.

CREATE TABLE Product (
  ProductID   NUMBER PRIMARY KEY,
  ProductName VARCHAR2(100),
  Category    VARCHAR2(50),
  UnitPrice   NUMBER(10,2),
  VolumeML    NUMBER,
  Status      VARCHAR2(20)
);
 CREATE TABLE Batch (
  BatchID         NUMBER PRIMARY KEY,
  ProductID       NUMBER,
  ProductionDate  DATE,
  Quantity        NUMBER,
  ExpiryDate      DATE,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Distributor (
  DistributorID NUMBER PRIMARY KEY,
  Name          VARCHAR2(100),
  Contact       VARCHAR2(50),
  Region        VARCHAR2(50),
  LicenseNo     VARCHAR2(30)
);
CREATE TABLE Delivery (
  DeliveryID     NUMBER PRIMARY KEY,
  BatchID        NUMBER,
  DistributorID  NUMBER,
  DateDelivered  DATE,
  Quantity       NUMBER,
  FOREIGN KEY (BatchID) REFERENCES Batch(BatchID),
  FOREIGN KEY (DistributorID) REFERENCES Distributor(DistributorID)
);
CREATE TABLE Invoice (
  InvoiceID     NUMBER PRIMARY KEY,
  DeliveryID    NUMBER,
  TotalAmount   NUMBER(10,2),
  DueDate       DATE,
  Status        VARCHAR2(20),
  FOREIGN KEY (DeliveryID) REFERENCES Delivery(DeliveryID)
);
CREATE TABLE Payment (
  PaymentID    NUMBER PRIMARY KEY,
  InvoiceID    NUMBER,
  Amount       NUMBER(10,2),
  PaymentDate  DATE,
  Method       VARCHAR2(30),
  FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
);
Q2. Apply CASCADE DELETE between Invoice → Payment.
CREATE TABLE Payment (
  PaymentID INT PRIMARY KEY,
  InvoiceID INT,
  Amount DECIMAL(10,2) CHECK (Amount > 0),
  PaymentDate DATE,
  Method VARCHAR(20),
  FOREIGN KEY (InvoiceID) REFERENCES Invoice(InvoiceID)
    ON DELETE CASCADE
);
Q3. Insert 5 products, 3 distributors, and 10 deliveries.
--INSERT DATA
--product
INSERT INTO Product VALUES (1, 'Inyange Juice Mango', 'juice', 1200, 500, 'Active');
INSERT INTO Product VALUES (2, 'Mitzing Beer', 'Alcoholic', 1500, 330, 'Active');
INSERT INTO Product VALUES (3, 'Sawa Water', 'Water', 500, 1000, 'Active');
INSERT INTO Product VALUES (4, 'Primus Beer', 'Alcoholic', 1300, 500, 'Active');
INSERT INTO Product VALUES (5, 'Inyange Milk', 'Dairy', 800, 500, 'Active');
select * from product

-- distrubutor
INSERT INTO Distributor VALUES (101, 'Rwanda Beverage LTD', '0788123456', 'Kigali', 'LIC-2025-KGL');
INSERT INTO Distributor VALUES (102, 'Eastern Drinks Co', '0788456789', 'Rwamagana', 'LIC-2025-RWA');
INSERT INTO Distributor VALUES (103, 'Western Refreshments', '0788567890', 'Rubavu', 'LIC-2025-RUB');
SELECT * FROM Distributor;

-- Insert deliveries
INSERT INTO Delivery VALUES (301, 201, 101, DATE '2025-10-1', 500);
INSERT INTO Delivery VALUES (302, 202, 102, DATE '2025-10-2', 300);
INSERT INTO Delivery VALUES (303, 203, 103, DATE '2025-10-3', 400);
INSERT INTO Delivery VALUES (304, 204, 101, DATE '2025-10-4', 600);
INSERT INTO Delivery VALUES (305, 205, 102, DATE '2025-10-5', 350);
INSERT INTO Delivery VALUES (306, 206, 103, DATE '2025-10-6', 450);
INSERT INTO Delivery VALUES (307, 207, 101, DATE '2025-10-7', 700);
INSERT INTO Delivery VALUES (308, 208, 102, DATE '2025-10-8', 250);
INSERT INTO Delivery VALUES (309, 209, 103, DATE '2025-10-9', 500);
INSERT INTO Delivery VALUES (310, 210, 101, DATE '2025-10-10',550);

select * from delivery;
Q4. Retrieve total sales per region.
SELECT d.Region, SUM(i.TotalAmount) AS TotalSales
FROM Distributor d
JOIN Delivery del ON d.DistributorID = del.DistributorID
JOIN Invoice i ON del.DeliveryID = i.DeliveryID
GROUP BY d.Region;
Q5. Update invoice status after payment completion.
UPDATE Invoice
SET Status = 'Paid'
WHERE InvoiceID = 301;
Q6. Identify distributors with overdue invoices.
SELECT DISTINCT d.DistributorID, d.Name, d.Region
FROM Distributor d
JOIN Delivery del ON d.DistributorID = del.DistributorID
JOIN Invoice i ON del.DeliveryID = i.DeliveryID
WHERE i.Status != 'Paid'
  AND i.DueDate < CURRENT_DATE;
Q7.Create a view showing total revenue per product.
 CREATE VIEW ProductRevenue AS
SELECT 
  p.ProductID,
  p.ProductName,
  SUM(i.TotalAmount) AS TotalRevenue
FROM Product p
JOIN Batch b ON p.ProductID = b.ProductID
JOIN Delivery d ON b.BatchID = d.BatchID
JOIN Invoice i ON d.DeliveryID = i.DeliveryID
GROUP BY p.ProductID, p.ProductName;
Q8.Implement a trigger marking batches expired after the expiry date.
CREATE OR REPLACE TRIGGER MarkBatchExpired
AFTER INSERT OR UPDATE ON Batch
FOR EACH ROW
BEGIN
  IF :NEW.ExpiryDate < SYSDATE THEN
    UPDATE Batch
    SET Status = 'Expired'
    WHERE BatchID = :NEW.BatchID;
  END IF;
END;










