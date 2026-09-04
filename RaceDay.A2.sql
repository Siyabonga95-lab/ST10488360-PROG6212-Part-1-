CREATE DATABASE RaceDay;
Use RaceDay; 

/*---------- DROP TABLES (in reverse dependency order, so re-runs don't error) ----------*/
IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.EventEnrollment', 'U') IS NOT NULL DROP TABLE dbo.EventEnrollment;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Events', 'U') IS NOT NULL DROP TABLE dbo.Events;
IF OBJECT_ID('dbo.Organiser', 'U') IS NOT NULL DROP TABLE dbo.Organiser;
IF OBJECT_ID('dbo.Participants', 'U') IS NOT NULL DROP TABLE dbo.Participants;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

/*---------- CREATE TABLES ----------*/

CREATE TABLE Users (
UserID INT IDENTITY(1,1) PRIMARY KEY,
UserName VARCHAR(50) UNIQUE NOT NULL,
PasswordHash VARCHAR(256) NOT NULL,
Role       VARCHAR(30) NOT NULL CHECK (Role IN ('Organiser','Participant')),
CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

-- The Profile details for accounts where the User.Role = 'Participant'.
CREATE TABLE Participants (
ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
UserID    INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserID),
ParticipantName VARCHAR(50) NOT NULL,
ParticipantEmail VARCHAR(100) UNIQUE NOT NULL,
ParticipantPhone VARCHAR(20) UNIQUE NOT NULL
);

-- The Profile detail for accounts where the User.Role = 'Organiser'.
CREATE TABLE Organiser (
OrganiserID INT IDENTITY(1,1) PRIMARY KEY,
UserID   INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Users(UserID),
OrganiserName VARCHAR(50) NOT NULL,
OrganiserEmail VARCHAR(100) UNIQUE NOT NULL,
OrganiserPhone VARCHAR(20) UNIQUE NOT NULL
);

-- The Route details  (map, start/end point) live directly on Events,
--Since each Event only needs one route description, not a separate table.
CREATE TABLE Events (
 EventID          INT IDENTITY(1,1) PRIMARY KEY,
 OrganiserID      INT NOT NULL FOREIGN KEY REFERENCES Organiser(OrganiserID),
 EventName        VARCHAR(100) NOT NULL,
 EventDescription VARCHAR(100) NOT NULL,
 EventDate        DATE NOT NULL,
 EventLocation    VARCHAR(100) NOT NULL,
 EventDistance    VARCHAR(5) NOT NULL,
 EventType        VARCHAR(20) NOT NULL CHECK (EventType IN ('Running','Walking','Cycling')),
 RouteStartPoint  VARCHAR(100) NULL,
 RouteEndPoint    VARCHAR(100) NULL,
 RouteMapUrl      VARCHAR(300) NULL
);

-- The Categories Table --
CREATE TABLE Categories (
CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
EventID    INT NOT NULL FOREIGN KEY REFERENCES Events(EventID),
CategoryAge INT NOT NULL,
CategoryDistance VARCHAR(5) NOT NULL
);

-- The EventEnrollment Table --
CREATE TABLE EventEnrollment (
EnrollmentID  INT IDENTITY(1,1) PRIMARY KEY,
EventID       INT NOT NULL FOREIGN KEY REFERENCES Events(EventID),
ParticipantID INT NOT NULL FOREIGN KEY REFERENCES Participants(ParticipantID),
CategoryID    INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID)
);

-- The Results Table --
CREATE TABLE Results (
 ResultID             INT IDENTITY(1,1) PRIMARY KEY,
 EnrollmentID         INT NOT NULL UNIQUE FOREIGN KEY REFERENCES EventEnrollment(EnrollmentID),
 Result_finish_time   TIME NOT NULL,
 Participant_position VARCHAR(5) NOT NULL
);

-- Two participants and two organisers, each starting with a Users login row.
INSERT INTO Users (UserName, PasswordHash, Role) VALUES
('michaelb', 'HASH_PLACEHOLDER_1', 'Participant'),
('emilyj', 'HASH_PLACEHOLDER_2', 'Participant'),
('johns', 'HASH_PLACEHOLDER_3', 'Organiser'),
('sarahw', 'HASH_PLACEHOLDER_4', 'Organiser');

INSERT INTO Participants (UserID, ParticipantName, ParticipantEmail, ParticipantPhone) VALUES
(1, 'Michael Brown', 'michael.brown@email.com', '0835552001'),
(2, 'Emily Jones', 'emily.jones@email.com', '0835552002');

INSERT INTO Organiser (UserID, OrganiserName, OrganiserEmail, OrganiserPhone) VALUES
(3, 'John Smith', 'john.smith@raceday.com', '0825551001'),
(4, 'Sarah Williams', 'sarah.williams@raceday.com', '0825551002');

INSERT INTO Events (OrganiserID, EventName, EventDescription, EventDate, eventLocation, EventDistance, EventType, routeStartPoint, RouteEndPoint, RouteMapUrl) VALUES
(1, 'Cape Town City Run', 'Annual city running event', '2026-09-12', 'Cape Town', '10KM', 'Running', 'V&A Waterfront', 'Green Point Park', NULL),
(2, 'Johannesburg Fun Run', 'Community running event', '2026-10-03', 'Johannesburg', '5KM', 'Running', 'Zoo Lake', 'Zoo Lake', NULL),
(1, 'Durban Beach Challenge', 'Beachside endurance event', '2026-11-14', 'Durban', '15KM', 'Walking', 'North Beach', 'uShaka Marine World', NULL);

INSERT INTO Categories (EventID, CategoryAge, CategoryDistance) VALUES
(1, 18, '10KM'),
(1, 30, '10KM'),
(1, 50, '10KM'),
(2, 18, '5KM'),
(2, 30, '5KM'),
(2, 50, '5KM'),
(3, 18, '15KM'),
(3, 30, '15KM'),
(3, 50, '15KM');

INSERT INTO EventEnrollment (EventID, ParticipantID, CategoryID) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 1, 4),
(2, 2, 5),
(3, 1, 7),
(3, 2, 8);

INSERT INTO Results (EnrollmentID, Result_finish_time, Participant_position) VALUES
(1, '00:52:35', '1'),
(2, '00:58:12', '2');

SELECT * FROM Users;
SELECT * FROM Organiser;
SELECT * FROM Participants;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM EventEnrollment;
SELECT * FROM Results;