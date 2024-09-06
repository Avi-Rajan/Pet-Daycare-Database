-- Create table for clients
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(15)
);

-- Create table for dogs
CREATE TABLE Dogs (
    dog_id INT PRIMARY KEY,
    client_id INT,
    name VARCHAR(50),
    breed VARCHAR(50),
    age INT,
    vaccination_status VARCHAR(20) NOT NULL, -- Making vaccination status required
    FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE
);

-- Create table for appointments
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    client_id INT,
    dog_id INT, -- Added dog_id column
    appointment_date DATE,
    appointment_time TIMESTAMP,
    service VARCHAR(50),
    staff_id INT,
    CONSTRAINT fk_client_id FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    CONSTRAINT fk_dog_id FOREIGN KEY (dog_id) REFERENCES Dogs(dog_id)
);

-- Create table for appointment logs
CREATE TABLE Appointment_Logs (
    log_id INT PRIMARY KEY,
    appointment_id INT,
    log_message VARCHAR2(4000), -- Adjust the length as needed
    log_date TIMESTAMP
);

-- Create a sequence to generate log_id values
CREATE SEQUENCE log_id_seq START WITH 1 INCREMENT BY 1;

-- Modify the Appointment_Logs table to use the sequence for log_id
ALTER TABLE Appointment_Logs MODIFY log_id DEFAULT log_id_seq.NEXTVAL;

-- Sample data for Clients table
INSERT INTO Clients (client_id, name, email, phone) VALUES (101, 'John Doe', 'john@example.com', '123-456-7890');
INSERT INTO Clients (client_id, name, email, phone) VALUES (102, 'Jane Smith', 'jane@example.com', '987-654-3210');

-- Sample data for Dogs table
INSERT INTO Dogs (dog_id, client_id, name, breed, age, vaccination_status) VALUES (23, 101, 'Max', 'Labrador', 3, 'Up to date');
INSERT INTO Dogs (dog_id, client_id, name, breed, age, vaccination_status) VALUES (26, 102, 'Buddy', 'Golden Retriever', 2, 'Outdated');

-- Sample data for Appointments table
INSERT INTO Appointments (appointment_id, client_id, dog_id, appointment_date, appointment_time, service, staff_id) VALUES (1, 101, 23, DATE '2024-04-23', TIMESTAMP '2024-04-23 10:00:00', 'Daycare', 1);
INSERT INTO Appointments (appointment_id, client_id, dog_id, appointment_date, appointment_time, service, staff_id) VALUES (2, 102, 26, DATE '2024-04-25', TIMESTAMP '2024-04-25 12:00:00', 'Grooming', 2);

-- Update appointment time for appointment_id 1
UPDATE Appointments SET appointment_time = TO_TIMESTAMP('2024-04-23 14:00:00', 'YYYY-MM-DD HH24:MI:SS') WHERE appointment_id = 1;

-- Example trigger for appointment reminders
CREATE OR REPLACE TRIGGER reminder_trigger
BEFORE INSERT ON Appointments
FOR EACH ROW
DECLARE
    v_appointment_date DATE;
    v_vaccination_status VARCHAR(20);
BEGIN
    -- Fetch the vaccination status of the dog associated with the appointment
    SELECT vaccination_status INTO v_vaccination_status FROM Dogs WHERE dog_id = :NEW.dog_id;
    
    -- Check if vaccination status is not up to date
    IF v_vaccination_status != 'Up to date' THEN
        v_appointment_date := :NEW.appointment_date;
        
        -- Log a message for appointment reminder
        INSERT INTO Appointment_Logs (log_id, appointment_id, log_message, log_date)
        VALUES (log_id_seq.NEXTVAL, :NEW.appointment_id, 'New appointment scheduled for dog with outdated vaccinations. Client ID: ' || :NEW.client_id || ', Service: ' || :NEW.service || ', Date: ' || TO_CHAR(v_appointment_date, 'YYYY-MM-DD') || ', Time: ' || TO_CHAR(:NEW.appointment_time, 'HH24:MI:SS'), SYSTIMESTAMP);
    END IF;
END;
/

-- Insert an appointment with appointment_id 344
INSERT INTO Appointments (appointment_id, client_id, dog_id, appointment_date, appointment_time, service, staff_id) 
VALUES (344, 102, 26, DATE '2024-04-24', TIMESTAMP '2024-04-24 10:00:00', 'Daycare', 1);

INSERT INTO Appointments (appointment_id, client_id, dog_id, appointment_date, appointment_time, service, staff_id) 
VALUES (347, 101, 23, DATE '2024-04-26', TIMESTAMP '2024-04-24 10:00:00', 'Daycare', 1);

-- Query to retrieve all logs
SELECT * FROM appointment_logs;

-- Example stored procedure for updating appointment time
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

-- Example usage of the stored procedure to update appointment time
EXECUTE UpdateAppointmentTime(4, TO_TIMESTAMP('18:00:00', 'HH24:MI:SS'));

-- Query to get all dogs and their owners
SELECT Dogs.Name AS DogName, Clients.Name AS OwnerName 
FROM Dogs 
INNER JOIN Clients ON Dogs.Client_ID = Clients.Client_ID;

-- Query to retrieve all bookings for a specific dog
SELECT * FROM Appointments 
WHERE dog_id = 23;