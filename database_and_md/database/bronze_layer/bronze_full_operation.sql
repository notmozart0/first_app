/*
this script creates the tables of the bronze schema (phase one).
>> a table for each csv file <<
then load it from files with the same name of table.
it dosen't operate any data transaction  or cleanig (at least in this phase).
=======================================================================================
                       instruction to operate the code properly:
=======================================================================================
to run the code properly you must run the entier code only once and if you want to load the 
tables agine you must only run the next code: 

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (USE ToursimDatabase;  GO   EXEC bronze.treating_tables;) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

warnning: do not run the main code more than one time to avoid overwriting  or any possible  error.
*/

/*================================================
              creation of the schema
==================================================*/

USE master;

GO

CREATE DATABASE ToursimDatabase;

GO

USE ToursimDatabase;

GO 

CREATE SCHEMA bronze ;

GO 

/*==================================================================
              creation of the tables and loading theme
====================================================================*/


CREATE OR ALTER PROCEDURE bronze.treating_tables AS

DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();


		SET @start_time = GETDATE();
			PRINT '>> treating users table <<';

			IF OBJECT_ID ('bronze.users', 'U') IS NULL 
			BEGIN
			CREATE TABLE bronze.users (
				user_id INT IDENTITY(1,1) PRIMARY KEY,
				user_role NVARCHAR (55) NOT NULL
						CHECK (user_role IN ('Admin', 'User')),
				user_email NVARCHAR (255) UNIQUE NOT NULL,
				user_password NVARCHAR (255) NOT NULL 
						CHECK (LEN(user_password) > 8),
				first_name NVARCHAR (50) NOT NULL,
				last_name NVARCHAR (50) NOT NULL,
				phone_number NVARCHAR(15) ,
				profile_picture VARBINARY(MAX),
				user_create_date DATETIME2 DEFAULT GETDATE()
				);
			END 
					BULK INSERT bronze.users 
					FROM 'D:\projects\toursim app\database\users.csv'
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						TABLOCK,
						KEEPIDENTITY
					);

				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------';



			SET @start_time = GETDATE();
			PRINT '>> treating places table <<';
			IF OBJECT_ID ('bronze.places', 'U') IS NULL
			BEGIN
			CREATE TABLE bronze.places (
				place_id INT IDENTITY(1,1) PRIMARY KEY,
				place_name NVARCHAR (70) NOT NULL,
				place_type NVARCHAR (50) NOT NULL,
				rating DECIMAL(3, 2),
				discrption NVARCHAR (MAX) 
						CHECK (LEN(discrption) > 10),
				phone_number NVARCHAR(15) NOT NULL,
				website_url NVARCHAR (MAX),
				opening_hours NVARCHAR (55),
				place_location NVARCHAR (MAX),
				place_create_date DATETIME2 DEFAULT GETDATE()
				);
			END 
					BULK INSERT bronze.places
					FROM 'D:\projects\toursim app\database\places.csv'
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						TABLOCK,
						KEEPIDENTITY
					);

				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------';



			SET @start_time = GETDATE();
			PRINT '>> treating reviwes table <<';
			IF OBJECT_ID ('bronze.reviwes', 'U') IS NULL
			BEGIN
			CREATE TABLE bronze.reviews (
				review_id INT IDENTITY(1,1) PRIMARY KEY,

				place_id INT NULL,
				local_id INT NULL,
				rating DECIMAL(3, 2),
				review_text NVARCHAR(MAX) NOT NULL,
				review_date DATETIME2 DEFAULT GETDATE(),

				CONSTRAINT FK_reviews_places
					FOREIGN KEY (place_id)
					REFERENCES bronze.places(place_id),

				CONSTRAINT FK_reviews_locals
					FOREIGN KEY (local_id)
					REFERENCES bronze.locals(local_id),

				CONSTRAINT CHK_only_one_target
					CHECK (
						(place_id IS NOT NULL AND local_id IS NULL)
						OR
						(place_id IS NULL AND local_id IS NOT NULL)
					)
			);
			END 
					BULK INSERT bronze.reviwes 
					FROM 'D:\projects\toursim app\database\reviwes.csv'
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						TABLOCK,
						KEEPIDENTITY
					);
				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';



			SET @start_time = GETDATE();
			PRINT '>> treating locals table <<';
			IF OBJECT_ID ('bronze.locals', 'U') IS NULL 
			BEGIN
			CREATE TABLE bronze.locals (
				local_id INT IDENTITY(1,1) PRIMARY KEY,
				first_name NVARCHAR (50) NOT NULL,
				last_name NVARCHAR (50) NOT NULL,
				rating DECIMAL(3, 2),
				years_experience INT,
				discrption NVARCHAR (MAX) 
						CHECK (LEN(discrption) > 10),
				local_photo VARBINARY(MAX)
				);
			END 
					BULK INSERT bronze.locals 
					FROM 'D:\projects\toursim app\database\locals.csv'
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						TABLOCK,
						KEEPIDENTITY
					);

				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -----------------------';



			SET @start_time = GETDATE();
			PRINT '>> treating media table <<';
			IF OBJECT_ID ('bronze.media', 'U') IS NULL 
			BEGIN
			CREATE TABLE bronze.media (
				photo_id INT IDENTITY(1,1) PRIMARY KEY,
				place_id INT NOT NULL,
				photo_url NVARCHAR (MAX),
				caption NVARCHAR (MAX)

				CONSTRAINT FK_media_places
					FOREIGN KEY (place_id)
					REFERENCES bronze.places(place_id),
				);
			END 
					BULK INSERT bronze.media 
					FROM 'D:\projects\toursim app\database\media.csv'
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						TABLOCK,
						KEEPIDENTITY
					);

				SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ------------------------';


				SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
END TRY

BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
END CATCH
