
# Doggy Daycare Database Project

## Introduction

In the current landscape of pet care, there is a significant demand for dependable daycare services catering to our beloved dogs. This project aims to create a streamlined SQL database system using SQL Developer, specifically designed to manage a doggy daycare facility. The primary objectives include creating essential tables for client data, appointment scheduling, and dog profiles. Advanced features like automated reminders, comprehensive reporting, and front-end application compatibility are also considered.

This project was inspired by personal experience—after recently adopting a dog and using Rover for overnight boarding, I wondered if I could create a database that could rival Rover and reduce the overall cost of boarding your pet.

## Exploring

I began this project without much knowledge of how databases in this industry function. To gather information, I reviewed Reddit discussions on services like Wag and Rover and spoke with a friend who works at a vet clinic. These interactions provided me with the necessary insights to design the database effectively.

## Building

The database includes tables for clients, dogs, and appointments, with foreign key constraints ensuring data integrity. Mock data was used to populate the tables, including owner details, dog profiles, vaccination records, and appointment details. Basic SQL queries were implemented for appointment scheduling and modification, along with simple views for staff reference. Additionally, I explored advanced features like stored procedures, triggers, and integration with front-end applications.

## Discovering

Throughout this project, I learned the importance of database design in addressing specific business needs and ensuring data integrity. I gained hands-on experience in SQL development, including query optimization and automation using stored procedures and triggers. While I achieved the minimum viable product goal, I identified areas for improvement, such as linking with front-end interfaces. With my growing experience in working with triggers and procedures, I can now develop these features more efficiently, leaving more time to focus on front-end integration.

## Database Normalization

This project heavily relies on fundamental database design principles. For instance, I utilized primary keys, foreign keys, and constraints to ensure data integrity within the database schema. The tables for clients, dogs, and appointments demonstrate the normalization process, reducing redundancy and enhancing efficiency.

### Example of creating tables with primary and foreign keys:

```sql
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE Dogs (
    dog_id INT PRIMARY KEY,
    client_id INT,
    name VARCHAR(50),
    breed VARCHAR(50),
    age INT,
    vaccination_status VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);
```

## SQL Query Optimization

In this project, I optimized SQL queries to enhance database performance. For example, when updating appointment times, I used stored procedures for efficient execution. This approach reduces network traffic and improves scalability.

### Example of a stored procedure for updating appointment time:

```sql
CREATE OR REPLACE PROCEDURE UpdateAppointmentTime(
    p_appointment_id INT,
    p_new_time TIMESTAMP
) AS
BEGIN
    UPDATE Appointments
    SET appointment_time = p_new_time
    WHERE appointment_id = p_appointment_id;
END;
/
```

## SQL Triggers

I used triggers to automate certain actions within the database. For instance, I implemented a trigger for appointment reminders that logs messages when new appointments are scheduled. Triggers enhance data consistency and automatically enforce business rules.

### Example trigger for appointment reminders:

```sql
CREATE OR REPLACE TRIGGER reminder_trigger
BEFORE INSERT ON Appointments
FOR EACH ROW
DECLARE
    v_appointment_date DATE;
BEGIN
    v_appointment_date := :NEW.appointment_date;

    -- Log a message when a new appointment is inserted
    INSERT INTO Appointment_Logs (appointment_id, log_message, log_date)
    VALUES (:NEW.appointment_id, 'New appointment scheduled. Client ID: ' || :NEW.client_id || ' Service: ' || :NEW.service || ' Date: ' || TO_CHAR(v_appointment_date, 'YYYY-MM-DD') || ' Time: ' || TO_CHAR(:NEW.appointment_time, 'HH24:MI:SS'), SYSDATE);
END;
/
```

## Data Population and Manipulation

Throughout the project, I focused on populating the database with mock data and manipulating it to simulate real-world scenarios. For this project, I used Mockaroo to insert data into the Clients table and the Dogs table. Some examples of the inserted data are included in the attached files named `Clients.sql` and `Dogs.sql`.

## Using SQL Queries to Join Tables and Search for Entries

I utilized SQL queries to join tables and search for specific entries, enabling efficient data retrieval and analysis.

### Example query to retrieve dog and owner names by joining Dogs and Clients tables:

```sql
SELECT Dogs.Name AS DogName, Clients.Name AS OwnerName
FROM Dogs
INNER JOIN Clients ON Dogs.Client_ID = Clients.Client_ID;
```

### Example query to retrieve all bookings for a specific dog:

```sql
SELECT * FROM Appointments WHERE dog_id = 23;
```

This integrated approach illustrates the practical application of database concepts in developing a comprehensive solution for managing a doggy daycare facility.
