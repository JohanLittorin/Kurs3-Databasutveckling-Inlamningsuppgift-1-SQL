USE SojasDatabasA;
GO

--      G-frågor.
--      1. Lista alla produkters namn och antal i lager. Listan ska vara sorterad på antal i lager med lägst värde först.
SELECT p.ProductName, p.Balance 
FROM Product p 
ORDER BY p.Balance ASC;

--      2. Lista butikens avdelningars namn tillsammans med namnet på personen som är ansvarig för varje avdelning.
SELECT p.PersonName, d.DepartmentName FROM Person p 
JOIN Manager m ON p.PersonID = m.PersonID
JOIN Department d ON d.DepartmentID = m.DepartmentID


--      3. Skriv en fråga som räknar ut antalet anställda i butiken.
SELECT COUNT (*) AS NumberofEmployee FROM Person;

--      4. Lista alla produkters i avdelningen "Mejeri" som har tre eller färre kvar i lagret.
SELECT p.ProductName, p.Balance FROM Product p 
JOIN ProductDepartment pd ON p.ProductID = pd.ProductID 
JOIN Department d ON pd.DepartmentID = d.DepartmentID 
WHERE p.Balance <= 3 AND d.DepartmentID = 1;


--      VG-frågor.
--      5. Lista alla produkter med deras pris. Om produkten är del av en kampanj ska det justerade priset visas istället.
Select Product.ProductID, ProductName, Price, Discount, 
CASE WHEN Campaign.CampaignID IS NULL 
THEN Price ELSE Price * Discount END AS DisplayPrice
FROM Product 
LEFT JOIN Campaign On Product.CampaignID = Campaign.CampaignID
ORDER BY Price ASC;

--      6. Skriv en fråga som räknar ut antalet anställda som inte är ansvariga för en avdelning. 
SELECT COUNT (*) AS NumberofNonBosses 
FROM Manager m
JOIN Person p ON p.PersonID = m.PersonID
WHERE m.DepartmentID IS NULL;


--      7. Lista alla anställda som är födda före år 2000.
SELECT * FROM Person WHERE PersonNumber < 200001010000;
