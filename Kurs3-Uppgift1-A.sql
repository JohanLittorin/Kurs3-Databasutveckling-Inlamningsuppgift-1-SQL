USE MASTER
--		Tar bort en gammal Databas och ersätter med en ny med samma namn
IF EXISTS (SELECT * FROM sysdatabases WHERE NAME='SojasDatabasA')
ALTER DATABASE [SojasDatabasA] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE SojasDatabasA
GO

CREATE DATABASE SojasDatabasA

GO

USE SojasDatabasA

CREATE TABLE Campaign (CampaignID INT PRIMARY KEY, CampaignName NVARCHAR(25), Discount FLOAT);
CREATE TABLE Person (PersonID INT PRIMARY KEY NOT NULL, PersonName NVARCHAR(50) NOT NULL, PersonNumber BIGINT UNIQUE NOT NULL);
CREATE TABLE Contact (PersonID INT FOREIGN KEY REFERENCES Person(PersonID) NOT NULL, PhoneNumber INT NOT NULL, HomeNumber INT);
CREATE TABLE Department (DepartmentID INT PRIMARY KEY, DepartmentName NVARCHAR(35));
CREATE TABLE Product (ProductID INT PRIMARY KEY, ProductName NVARCHAR(35), Balance INT, Price INT, ExpirationDate INT, TableoFContent NVARCHAR(70), CampaignID INT, DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID), BalanceStatus NVARCHAR(20));
CREATE TABLE Inventory (InventoryID INT PRIMARY KEY, InventoryDate DATE, PersonID INT FOREIGN KEY REFERENCES Person(PersoNID));
CREATE TABLE ProductDepartment (ProductID INT FOREIGN KEY REFERENCES Product(ProductID), DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID));
CREATE TABLE Manager (PersonID INT FOREIGN KEY REFERENCES Person(PersonID) NOT NULL, DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID));
GO
--		Testade en Cursor, så gjorde en tabell för det
CREATE TABLE BalanceCursor (ProductID INT, ProductName NVARCHAR(50), AlertType NVARCHAR(50));
GO

INSERT INTO Campaign (CampaignID, CampaignName, Discount)
VALUES
(1, 'REA', 0.90);
GO

INSERT INTO Department (DepartmentID, DepartmentName)
VALUES
(1, 'Mejeri'),
(2, 'Frukt'),
(3, 'Skafferi'),
(4, 'Dryck'),
(5, 'Bröd'),
(6, 'Köttdisk');
GO

INSERT INTO Person (PersonID, PersonName, PersonNumber)
VALUES
(1, 'Johan Svensson', 198108146631),
(2, 'Andreas Karlsson', 199202106459),
(3, 'Bea Nilsson', 200105136301),
(4, 'Lena Hansson', 197611046603),
(5, 'Per Läckberg', 197503036675),
(6, 'Bertil Strid', 200110236607),
(7, 'Henning Steen', 200211046655);
GO

INSERT INTO Manager(PersonID, DepartmentID)
VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, NULL),
(7, NULL);
GO


INSERT INTO Contact (PersonID, PhoneNumber, HomeNumber)
VALUES
(1, 0770882200, 019101010),
(2, 0734771122, NULL),
(3, 0704626262, NULL),
(4, 0703121314, NULL), 
(5, 0720215687, NULL),
(6, 0734567890, NULL);
GO

INSERT INTO Product (ProductID, ProductName, Balance, Price, ExpirationDate, TableoFContent, CampaignID, DepartmentID, BalanceStatus)
VALUES
(1, 'Mjölk', 8, 21, 20210114, 'Protein, Kolhydrater, fett, vatten', 1, 1, NULL), 
(2, 'Fil', 5, 24, 20210113, 'Protein, Kolhydrater, fett, vatten', 1, 1, NULL),
(3, 'Grädde', 2, 30, 20210120, 'Protein, Kolhydrater, fett', NULL, 1, NULL),
(4, 'Äpple', 45, 4, 20210204, 'Kolhydrater, fibrer, vatten', 1, 2, NULL),
(5, 'Banan', 2, 3, 20210110, 'Protein, kolhydrater, fibrer', NULL, 2, NULL),
(6, 'Päron', 25, 5, 20210206, 'Kolhydrater, fibrer, vatten', 1, 2, NULL),
(7, 'Havregryn', 10, 21, 20221019, 'Kolhydrater, fibrer, protein', NULL, 3, NULL),
(8, 'Mjöl', 14, 20, 20231102, 'Protein, kolhydrater, natrium', NULL, 3, NULL),
(9, 'Socker', 4, 25, 20240203, 'Kolhydrater, vatten', NULL, 3, NULL),
(10, 'Kolsyrat vatten', 24, 10, 20231101, 'Vatten', NULL, 4, NULL),
(11, 'Coca-Cola', 67, 10, 20211209, 'Vatten, kolhydrater', NULL, 4, NULL),
(12, 'Carlsberg Öl', 13, 14, 20211020, 'Vatten, kolestrol, humle', 1, 4, NULL),
(13, 'Kanelbullar', 1, 6, 20210109, 'Kolhydrater, vatten, fett', 1, 5, NULL),
(14, 'Lantbröd', 3, 32, 20210111, 'Vatten, mjöl, salt', NULL, 5, NULL),
(15, 'Skorpor', 19, 29, 20210304, 'Vatten, fibrer, mjöl', NULL, 5, NULL),
(16, 'Grillkorv', 2, 54, 20210204, 'Protein, fett, antibiotika', NULL, 6, NULL),
(17, 'Köttfärs', 4, 159, 20210120, 'Protein, vatten, antibiotika', 1, 6, NULL),
(18, 'Fläskfile', 5, 179, 20210309, 'Protein, vatten, antibiotika', NULL, 6, NULL);
GO

INSERT INTO Inventory (InventoryID, InventoryDate, PersonID)
VALUES
(1, '20201222', 1),
(2, '20210128', 2);
GO

INSERT INTO ProductDepartment (ProductID, DepartmentID)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3),
(9, 3),
(10, 4),
(11, 4),  -- Cola finns på flera avdelningar
(11, 5),
(11, 6),
(12, 4),
(13, 5),
(14, 5),
(15, 5),
(16, 6),
(17, 6),
(18, 6);
GO

--     VG-Uppgifter
--     1. Skapa en trigger som sätter ett värde på alla produkter som snart är slut. 
--     Dvs, lägg till en kolumn som du kan kalla ProductStatus. Denna kolumn ska antingen ha värdet ”OK” eller ”Snart slut”. 
--     Värdet ”Snart slut” ska sättas om det finns 3 eller färre produkten kvar. Annars är statusen ”OK”. 

CREATE TRIGGER Balance_Trigger
ON PRODUCT
FOR INSERT
AS 
BEGIN
UPDATE Product
SET  Product.BalanceStatus =
CASE WHEN Product.Balance > 3 THEN 'OK' ELSE 'Snart Slut'
END
END
GO

--		Testning av Triggern
INSERT INTO Product (ProductID, ProductName, Balance, Price, ExpirationDate, TableoFContent, CampaignID, DepartmentID) VALUES (19, 'Kiwi', 2, 11, 20210212, 'TestForTrigger', NULL, 2);
INSERT INTO Product (ProductID, ProductName, Balance, Price, ExpirationDate, TableoFContent, CampaignID, DepartmentID) VALUES (20, 'Melon', 5, 11, 20210212, 'Test2ForTrigger', NULL, 2);

SELECT * FROM Product

--      När jag googlade om Trigger hittade jag även Cursor, så testade även med en sån.


DECLARE @ProductID INT;
DECLARE @Balance INT;
DECLARE @ProductName NVARCHAR(50);
DECLARE @BalanceCursor AS CURSOR;
SET @BalanceCursor = CURSOR FOR
SELECT ProductID, ProductName, Balance FROM Product;

OPEN @BalanceCursor;
FETCH NEXT FROM @BalanceCursor INTO @ProductID, @ProductName, @Balance;
WHILE @@FETCH_STATUS = 0
BEGIN 
	IF @Balance <= 3 INSERT INTO BalanceCursor(ProductID, ProductName, AlertType) VALUES (@ProductID, @ProductName,'Snart Slut')
	ELSE INSERT INTO BalanceCursor(ProductID, ProductName, AlertType) VALUES (@ProductID, @ProductName,'OK')
	FETCH NEXT FROM @BalanceCursor INTO @ProductID, @ProductName, @Balance;
END
CLOSE @BalanceCursor;
DEALLOCATE @BalanceCursor;
GO

--		Testning av Cursor
SELECT * FROM BalanceCursor


--      2. Skapa ett kompositindex för en produkts utgångsdatum och antalet i lager.

CREATE INDEX ExpirationDateAndBalance_idx ON Product(ExpirationDate, Balance);
GO
