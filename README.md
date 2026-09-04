# RaceDay — Part 1: System Planning and Database

**Student:** ST10488360
**Module:** PROG6212

## What this project is

RaceDay is a system for managing running, walking, and cycling events. Organisers can create events, set up categories, and capture results. Participants can browse events, enter them, and check their own results afterwards. This repo covers Part 1 only — planning the system before any application code is written.

## Repository structure

```
/docs
  RaceDay_ERD.png
  RaceDay_Database.sql
  RaceDay_API_Endpoint_Plan.md
  RaceDay_Part1_Planning_and_Design.docx
  ci-success-screenshot.png
.github/workflows/validate-part1.yml
README.md
```

## Roles

- **Organiser** — creates, edits, and deletes events, manages categories, captures results, and views all enrolments for their events.
- **Participant** — registers, browses events, enters an event by picking a category, and views their own enrolments and results.

## Database design

The database has 7 tables: Users, Participants, Organiser, Events, Categories, EventEnrollment, and Results.

Users holds login details only — username, password hash, and role. Participants and Organiser each hold the profile details for their role (name, email, phone), linked back to Users by a one-to-one foreign key. I split it this way because Organisers and Participants don't share much beyond logging in, so keeping login separate from profile data made more sense than one big table with unused columns.

Route details (start point, end point, map URL) are stored directly on the Events table instead of a separate table, since one event only ever has one route.

EventEnrollment links a Participant, an Event, and a Category together whenever someone enters an event. Results are linked to an enrolment rather than straight to a participant, so a result can never be confused with the wrong race if someone enters more than one event.

Full reasoning for these decisions is written up in RaceDay_Part1_Planning_and_Design.docx in /docs.

## How to run my SQL script

1. Open SQL Server Management Studio and connect to your instance.
2. Open docs/RaceDay_Database.sql.
3. Select the entire script and run it.
4. It creates the database, drops and recreates all tables, and seeds sample data: 2 Organisers, 2 Participants, 3 Events, categories for each event, and sample enrolments and results.
5. Check the Messages tab for errors, then confirm all 7 tables appear with data.

## API endpoint plan

The full endpoint plan, covering Authentication, User Profile, Events, Categories, Event Enrolments, Results, and an additional Weather endpoint I identified, is in docs/RaceDay_API_Endpoint_Plan.md. Every endpoint lists its HTTP method, route, description, required role, request body, and expected response including failure cases.

