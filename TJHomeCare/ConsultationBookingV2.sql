USE [tabletjobs-db];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/* Add the fields needed by the redesigned consultation booking flow.
   Existing BookingID, caregiver, service and customer columns are retained. */
IF COL_LENGTH('sqladmin.ConsultationBookings', 'AppointmentDate') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [AppointmentDate] DATE NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'AppointmentTime') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [AppointmentTime] NVARCHAR(10) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'ConsultationReason') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [ConsultationReason] NVARCHAR(1000) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'BookingReference') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [BookingReference] NVARCHAR(40) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'ConsultationFee') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [ConsultationFee] DECIMAL(10,2) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'GSTPercent') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [GSTPercent] DECIMAL(5,2) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'GSTAmount') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [GSTAmount] DECIMAL(10,2) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'TotalAmount') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [TotalAmount] DECIMAL(10,2) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PaymentStatus') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PaymentStatus] NVARCHAR(20) NOT NULL CONSTRAINT [DF_ConsultationBookings_PaymentStatus] DEFAULT ('Pending') WITH VALUES;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PaymentGateway') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PaymentGateway] NVARCHAR(30) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PaymentOrderID') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PaymentOrderID] NVARCHAR(100) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PaymentTransactionID') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PaymentTransactionID] NVARCHAR(100) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PaidOn') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PaidOn] DATETIME NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'PublicToken') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [PublicToken] NVARCHAR(64) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'CancellationRequestedOn') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [CancellationRequestedOn] DATETIME NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'RescheduleRequestedOn') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [RescheduleRequestedOn] DATETIME NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'RequestedAppointmentDate') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [RequestedAppointmentDate] DATE NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'RequestedAppointmentTime') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [RequestedAppointmentTime] NVARCHAR(10) NULL;
GO
IF COL_LENGTH('sqladmin.ConsultationBookings', 'CustomerRequestNote') IS NULL
    ALTER TABLE [sqladmin].[ConsultationBookings] ADD [CustomerRequestNote] NVARCHAR(500) NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_ConsultationBookings_BookingReference' AND object_id = OBJECT_ID('sqladmin.ConsultationBookings'))
    CREATE UNIQUE INDEX [UX_ConsultationBookings_BookingReference]
    ON [sqladmin].[ConsultationBookings] ([BookingReference]) WHERE [BookingReference] IS NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_ConsultationBookings_PublicToken' AND object_id = OBJECT_ID('sqladmin.ConsultationBookings'))
    CREATE UNIQUE INDEX [UX_ConsultationBookings_PublicToken]
    ON [sqladmin].[ConsultationBookings] ([PublicToken]) WHERE [PublicToken] IS NOT NULL;
GO

/* Service-wise rates are stored in the database. The page never accepts the
   fee or GST percentage from the customer's browser. */
IF OBJECT_ID('sqladmin.ConsultationServicePricing', 'U') IS NULL
BEGIN
    CREATE TABLE [sqladmin].[ConsultationServicePricing]
    (
        [ServiceCategoryID] INT NOT NULL PRIMARY KEY,
        [ConsultationFee] DECIMAL(10,2) NOT NULL,
        [GSTPercent] DECIMAL(5,2) NOT NULL CONSTRAINT [DF_ConsultationServicePricing_GSTPercent] DEFAULT (18),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_ConsultationServicePricing_IsActive] DEFAULT (1),
        [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_ConsultationServicePricing_UpdatedDate] DEFAULT (GETDATE())
    );
END;
GO

/* Sample rate from the supplied reference screenshot only.
   Add/update all other service rates after confirming your price list. */
INSERT INTO [sqladmin].[ConsultationServicePricing]
    ([ServiceCategoryID], [ConsultationFee], [GSTPercent], [IsActive], [UpdatedDate])
SELECT SC.[ServiceCategoryID], 999.00, 18.00, 1, GETDATE()
FROM [sqladmin].[ServiceCategories] SC
WHERE SC.[ServiceName] LIKE N'%Dermatologist%'
  AND NOT EXISTS
      (SELECT 1 FROM [sqladmin].[ConsultationServicePricing] P
       WHERE P.[ServiceCategoryID] = SC.[ServiceCategoryID]);
GO

/* One booking may have more than one payment attempt. Never store card number,
   CVV, PIN, OTP or other sensitive payment credentials in this table. */
IF OBJECT_ID('sqladmin.ConsultationBookingPayments', 'U') IS NULL
BEGIN
    CREATE TABLE [sqladmin].[ConsultationBookingPayments]
    (
        [PaymentID] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [BookingID] INT NOT NULL,
        [GatewayName] NVARCHAR(30) NOT NULL,
        [MerchantOrderID] NVARCHAR(100) NULL,
        [GatewayTransactionID] NVARCHAR(100) NULL,
        [Amount] DECIMAL(10,2) NOT NULL,
        [Currency] CHAR(3) NOT NULL CONSTRAINT [DF_ConsultationBookingPayments_Currency] DEFAULT ('INR'),
        [PaymentStatus] NVARCHAR(20) NOT NULL,
        [InitiatedOn] DATETIME NOT NULL CONSTRAINT [DF_ConsultationBookingPayments_InitiatedOn] DEFAULT (GETDATE()),
        [UpdatedOn] DATETIME NULL,
        [GatewayResponse] NVARCHAR(MAX) NULL,
        [IsVerified] BIT NOT NULL CONSTRAINT [DF_ConsultationBookingPayments_IsVerified] DEFAULT (0),
        CONSTRAINT [FK_ConsultationBookingPayments_ConsultationBookings]
            FOREIGN KEY ([BookingID]) REFERENCES [sqladmin].[ConsultationBookings] ([BookingID])
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ConsultationBookingPayments_BookingID' AND object_id = OBJECT_ID('sqladmin.ConsultationBookingPayments'))
    CREATE INDEX [IX_ConsultationBookingPayments_BookingID]
    ON [sqladmin].[ConsultationBookingPayments] ([BookingID], [InitiatedOn] DESC);
GO

/* Check the rows/rates inserted. Add the remaining service rates before testing. */
SELECT SC.ServiceCategoryID, SC.ServiceName,
       P.ConsultationFee, P.GSTPercent, P.IsActive
FROM [sqladmin].[ServiceCategories] SC
LEFT JOIN [sqladmin].[ConsultationServicePricing] P
    ON P.ServiceCategoryID = SC.ServiceCategoryID
WHERE SC.IsActive = 1
ORDER BY SC.DisplayOrder, SC.ServiceName;
GO


/* Ensure a merchant order id cannot be reused for another payment attempt. */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_ConsultationBookingPayments_MerchantOrderID' AND object_id = OBJECT_ID('sqladmin.ConsultationBookingPayments'))
    CREATE UNIQUE INDEX [UX_ConsultationBookingPayments_MerchantOrderID]
    ON [sqladmin].[ConsultationBookingPayments] ([MerchantOrderID])
    WHERE [MerchantOrderID] IS NOT NULL;
GO
