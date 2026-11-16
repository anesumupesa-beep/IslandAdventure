-- ============================================================
-- Island Escape Adventures - Database Setup Script
-- Run this in SQL Server Management Studio (SSMS)
-- against your local SQL Server 2019 instance
-- ============================================================

USE master;
GO

-- Create database (drop if exists for clean setup)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'IslandEscapeDB')
BEGIN
    ALTER DATABASE IslandEscapeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE IslandEscapeDB;
END
GO

CREATE DATABASE IslandEscapeDB;
GO

USE IslandEscapeDB;
GO

-- ============================================================
-- TABLE: Users
-- ============================================================
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    FullName     NVARCHAR(100)  NOT NULL,
    Email        NVARCHAR(150)  NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256)  NOT NULL,
    Phone        NVARCHAR(20)   NULL,
    Address      NVARCHAR(250)  NULL,
    Role         NVARCHAR(20)   NOT NULL DEFAULT 'Customer', -- 'Customer' or 'Admin'
    IsActive     BIT            NOT NULL DEFAULT 1,
    DateRegistered DATETIME     NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- TABLE: Packages
-- ============================================================
CREATE TABLE Packages (
    PackageID    INT IDENTITY(1,1) PRIMARY KEY,
    Name         NVARCHAR(150)  NOT NULL,
    Description  NVARCHAR(1000) NOT NULL,
    Price        DECIMAL(10,2)  NOT NULL,
    Category     NVARCHAR(50)   NOT NULL, -- Hotels, Dining, Airport Transfer, Excursions, Sea Activities
    ImageURL     NVARCHAR(300)  NOT NULL DEFAULT 'images/default-package.jpg',
    IsAvailable  BIT            NOT NULL DEFAULT 1,
    DateAdded    DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- TABLE: Cart
-- ============================================================
CREATE TABLE Cart (
    CartID       INT IDENTITY(1,1) PRIMARY KEY,
    UserID       INT            NOT NULL REFERENCES Users(UserID),
    PackageID    INT            NOT NULL REFERENCES Packages(PackageID),
    Quantity     INT            NOT NULL DEFAULT 1,
    DateAdded    DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

-- ============================================================
-- TABLE: Orders
-- ============================================================
CREATE TABLE Orders (
    OrderID        INT IDENTITY(1,1) PRIMARY KEY,
    UserID         INT            NOT NULL REFERENCES Users(UserID),
    OrderDate      DATETIME       NOT NULL DEFAULT GETDATE(),
    TotalAmount    DECIMAL(10,2)  NOT NULL,
    PaymentStatus  NVARCHAR(20)   NOT NULL DEFAULT 'Paid', -- 'Paid', 'Pending'
    CardLastFour   NVARCHAR(4)    NULL
);
GO

-- ============================================================
-- TABLE: OrderItems
-- ============================================================
CREATE TABLE OrderItems (
    OrderItemID  INT IDENTITY(1,1) PRIMARY KEY,
    OrderID      INT            NOT NULL REFERENCES Orders(OrderID),
    PackageID    INT            NOT NULL REFERENCES Packages(PackageID),
    Quantity     INT            NOT NULL,
    UnitPrice    DECIMAL(10,2)  NOT NULL
);
GO

-- ============================================================
-- TABLE: ContactQueries
-- ============================================================
CREATE TABLE ContactQueries (
    QueryID        INT IDENTITY(1,1) PRIMARY KEY,
    Name           NVARCHAR(100)  NOT NULL,
    Email          NVARCHAR(150)  NOT NULL,
    Subject        NVARCHAR(200)  NOT NULL,
    Message        NVARCHAR(2000) NOT NULL,
    DateSubmitted  DATETIME       NOT NULL DEFAULT GETDATE(),
    IsResolved     BIT            NOT NULL DEFAULT 0
);
GO

-- ============================================================
-- SEED DATA: Users
-- Passwords are SHA256 hashes.
-- Admin password:    Admin@123
-- Customer password: Customer@123
-- SHA256("Admin@123")    = e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7
-- SHA256("Customer@123") = 98ec654a8df28f8f0f8f02220483d46916b85017de0b74d8ec755c28cb8539a8
-- ============================================================
INSERT INTO Users (FullName, Email, PasswordHash, Phone, Address, Role, IsActive)
VALUES
(
    'Admin User',
    'admin@islandescape.mu',
    'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7',
    '+230 5900 0001',
    'Port Louis, Mauritius',
    'Admin',
    1
),
(
    'Jean-Paul Laborde',
    'jp.laborde@gmail.com',
    '98ec654a8df28f8f0f8f02220483d46916b85017de0b74d8ec755c28cb8539a8',
    '+230 5912 3456',
    '14 Rue Desforges, Curepipe, Mauritius',
    'Customer',
    1
);
GO

-- ============================================================
-- SEED DATA: Packages (10 packages across 5 categories)
-- ============================================================
INSERT INTO Packages (Name, Description, Price, Category, ImageURL, IsAvailable)
VALUES
-- Hotels (2)
(
    'Le Morne Beach Resort',
    'Indulge in luxury at our sea-view rooms overlooking the stunning Le Morne peninsula. Includes daily breakfast, pool access, and a welcome cocktail. Perfect for a romantic getaway or family holiday.',
    8500.00,
    'Hotels',
    'images/packages/hotel-lemorne.jpg',
    1
),
(
    'Tamarin Bay Boutique Hotel',
    'A charming boutique hotel nestled in the hills above Tamarin Bay. Enjoy garden suites with private terraces, a swimming pool, and easy access to the famous surf spot. Includes breakfast.',
    4200.00,
    'Hotels',
    'images/packages/hotel-tamarin.jpg',
    1
),
-- Dining (2)
(
    'Sunset Terrace - 3-Course Dinner for 2',
    'Experience fine dining at Sunset Terrace restaurant with breathtaking views of the Indian Ocean. Your 3-course dinner includes a starter, main course, and dessert with a complimentary bottle of wine.',
    2800.00,
    'Dining',
    'images/packages/dining-sunset.jpg',
    1
),
(
    'Creole Night Experience',
    'Immerse yourself in authentic Mauritian culture with a traditional Creole dinner and live sega music performance. Enjoy local dishes like dholl puri, rougaille, and gateau piments in a festive atmosphere.',
    1500.00,
    'Dining',
    'images/packages/dining-creole.jpg',
    1
),
-- Airport Transfer (2)
(
    'Private Airport Transfer (up to 4 pax)',
    'Travel in comfort from Sir Seewoosagur Ramgoolam International Airport to your hotel in an air-conditioned private vehicle. Available 24/7, meet-and-greet service included. Covers any destination on the island.',
    1200.00,
    'Airport Transfer',
    'images/packages/transfer-private.jpg',
    1
),
(
    'Shared Shuttle - Airport to Grand Baie',
    'Affordable shared shuttle service from the airport directly to Grand Baie. Runs on schedule, comfortable minibus with luggage space. Ideal for solo travellers and couples on a budget.',
    450.00,
    'Airport Transfer',
    'images/packages/transfer-shuttle.jpg',
    1
),
-- Excursions (2)
(
    'Chamarel 7 Coloured Earth & Waterfall Tour',
    'Discover the magical Chamarel coloured earth and the stunning 100m waterfall. Your guided full-day tour includes transport, entrance fees, and a traditional lunch at a local restaurant.',
    1800.00,
    'Excursions',
    'images/packages/excursion-chamarel.jpg',
    1
),
(
    'Black River Gorges Hiking Experience',
    'Explore Mauritius'' largest national park on a guided full-day hike through lush rainforest. Spot rare endemic birds, giant tortoises, and breathtaking viewpoints. Transport and packed lunch included.',
    950.00,
    'Excursions',
    'images/packages/excursion-hiking.jpg',
    1
),
-- Sea Activities (2)
(
    'Catamaran Cruise & Snorkelling - North Coast',
    'Sail the crystal-clear waters of the north coast aboard a luxury catamaran. Enjoy snorkelling at two reef sites, a freshly prepared BBQ lunch on board, and stops at stunning sandbanks.',
    2500.00,
    'Sea Activities',
    'images/packages/sea-catamaran.jpg',
    1
),
(
    'Dolphin Watching & Swimming - Tamarin Bay',
    'An unforgettable sunrise experience swimming with wild dolphins in Tamarin Bay. Includes boat trip, snorkelling equipment, light refreshments, and an expert marine guide.',
    1750.00,
    'Sea Activities',
    'images/packages/sea-dolphins.jpg',
    1
);
GO

-- ============================================================
-- SEED DATA: Sample Order (for purchase history demo)
-- ============================================================
INSERT INTO Orders (UserID, OrderDate, TotalAmount, PaymentStatus, CardLastFour)
VALUES (2, DATEADD(DAY, -10, GETDATE()), 4250.00, 'Paid', '4242');

INSERT INTO OrderItems (OrderID, PackageID, Quantity, UnitPrice)
VALUES
(1, 9, 1, 2500.00),  -- Catamaran Cruise
(1, 6, 2, 450.00);   -- 2x Shuttle
GO

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'Users'     AS [Table], COUNT(*) AS [Rows] FROM Users
UNION ALL
SELECT 'Packages',  COUNT(*) FROM Packages
UNION ALL
SELECT 'Orders',    COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderItems',COUNT(*) FROM OrderItems;
GO

PRINT 'IslandEscapeDB setup complete.';
GO
