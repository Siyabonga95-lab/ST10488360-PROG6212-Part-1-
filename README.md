# RaceDay — Part 1: System Planning and Design

Student: ST10488360


## What this project is

RaceDay is a system I'm building for South African road running, walking, and cycling events, so organisers can manage events online instead of using spreadsheets and paper forms. There are two types of users — Organisers, who create events, set up categories, and capture results, and Participants, who browse events, enter them, and check their own results afterwards.

Part 1 is just the planning stage — no application code is written here. This part covers the database design (ERD), the SQL script that creates and seeds the database, and a full plan of every API endpoint the system will need once I start building it in Part 2.

## Roles

- **Organiser** — creates, edits, and deletes events, manages categories for their events, captures participant results, and can view all enrolments for their events.
- **Participant** — registers an account, browses events, enrols in an event by picking a category, and can view their own enrolments and results.

## Repository Structure

```
/docs
  RaceDay_ERD.png                     -> Entity Relationship Diagram
  RaceDay_Database.sql                -> Full SQL schema and seed data
  RaceDay_API_Endpoint_Plan.md        -> Full API endpoint plan
  RaceDay_Part1_Planning_and_Design.docx -> Explanation of my design decisions

```

## Database Design

My database has 7 tables: Users, Participants, Organiser, Events, Categories, EventEnrollment, and Results.

I split login and profile info into separate tables instead of one big Users table with everything in it. Users only holds the login stuff — username, password hash, and role. Then Participants and Organiser each hold the profile details for their own role (name, email, phone), linked back to Users with a one-to-one foreign key. This way my login logic only ever checks one table, and once I know someone's role, I know exactly which second table to look in for the rest of their info.

Route details (start point, end point, map URL) are stored directly on the Events table instead of a separate table, since every event only has one route. EventEnrollment is its own table because enrolling links three things together at once — the participant, the event, and the category they picked. Results link to an enrolment rather than straight to a participant, so if someone enters more than one event, each result is still tied to the right race.

Full reasoning for every design decision is in `RaceDay_Part1_Planning_and_Design.docx` in /docs.

## How to Run My SQL Script

1. Open SQL Server Management Studio (SSMS) and connect to a SQL Server instance.
2. Open `docs/RaceDay_Database.sql`.
3. Run the whole script (F5) — don't run only part of it, since the earlier statements set up the database and drop old tables first.
4. It will create the RaceDay database, create all 7 tables with their keys and constraints, and insert sample data: 2 Organisers, 2 Participants, 3 Events, categories for each event, and a few enrolments and results.
5. Check the Messages tab for errors, then check that all 7 tables exist under `RaceDay > Tables` and have data in them.

## API Endpoint Plan

The full endpoint plan is in `docs/RaceDay_API_Endpoint_Plan.md`, covering Authentication, User Profile, Events, Categories, Event Enrolments, and Results, plus one extra endpoint I identified for fetching live weather for an event. Every endpoint lists its HTTP method, route, description, required role, request body, and expected response, including failure cases.
