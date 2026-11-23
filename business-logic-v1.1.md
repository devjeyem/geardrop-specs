# Business Logic v1.1

> Development of a web-first student equipment and lab-tool sharing platform using React, Node.js, and Supabase for verified university students.

- Allowed Platform: Web

## Project Details

- Company/Startup/Team Name: VisiCore
- Project Code Name: geardrop
- Project Short Code: GD
- Short Description: A privacy-first, non-monetary sharing board where verified students lend and borrow small academic and lab essentials within a pilot campus.
- Long Description: GearDrop helps students find currently available calculators, chargers, adapters, and lab tools from peers on campus. Students post time-limited listings, request an item, and close the borrow/return handoff. The platform uses coarse campus zones rather than precise or continuous location tracking.

## Product Scope

GearDrop is a campus sharing board, not a marketplace, rental service, rewards program, or asset-management system. The MVP serves one pilot campus and only low-risk, portable academic and lab-support equipment. Payments, credits, deposits, ratings, public reputation, live chat, maps, GPS tracking, delivery, and native Android are out of scope.

## User Levels

| User Level | Description |
| --- | --- |
| A. System Administrator | Maintains infrastructure, backups, recovery, and restricted operational settings. |
| B. Administrator | Manages categories, campus zones, approved email domains, staff access, and aggregate pilot metrics. |
| C. Moderator | Reviews flagged listings, resolves or dismisses reports, and hides listings that violate policy. |
| D. Contributor | A verified student who posts listings, sends or responds to borrow requests, records returns, and flags listings. |
| E. Guest | A visitor who may browse limited available listings by category; sign-in is required to see exact pickup zones or act. |

## System Requirements

1. The app shall allow users to sign in using Google Sign-In and shall permit Contributor access only to approved university Google domains.
2. The app shall allow Contributors to create, edit, and close time-limited item listings with a category, title, condition, campus zone, and available-until time.
3. The app shall allow Guests and Contributors to browse available, non-hidden listings by category and coarse campus zone. Guests shall not see lender identity or exact pickup details.
4. The app shall allow Contributors to send one borrow request for an available listing; the listing owner shall be able to accept or decline it, and the requester shall be able to cancel it.
5. The app shall lock a listing to the accepted request and track its status as `available`, `requested`, `borrowed`, `returned`, `closed`, or `expired`.
6. The app shall allow the request participants to record a return. A listing shall expire automatically at its available-until time unless it is already borrowed.
7. The app shall allow Contributors to flag unsafe, inappropriate, or non-compliant listings; Moderators shall resolve or dismiss reports and may hide a listing.
8. The app shall allow Administrators to manage item categories, campus zones, approved email domains, and aggregate pilot metrics.

## Required Solution Layers

1. **Privacy and security by design:** collect only the identity, listing, request/status, moderation, and aggregate data needed for the pilot. Do not collect continuous or precise location data.
2. **Access control:** limit the pilot to approved university accounts; restrict listing management to owners and status updates to request participants.
3. **Privacy-safe operations:** keep moderation outcomes and analytics out of public profiles; use aggregate metrics only and obtain explicit consent before any new data use or resale.
4. **Retention and safety:** define approved retention periods, campus zones, prohibited item categories, community rules, and incident escalation before launch.

## MVP Features and Access

| Feature | Access |
| --- | --- |
| 1. Browse limited available listings by category and campus zone | A, B, C, D, E |
| 2. Google sign-in and verified-student session | A, B, C, D |
| 3. Create, edit, close, and expire own item listings | D |
| 4. Request, accept, decline, cancel, and track a borrow/return handoff | D |
| 5. Flag listings; review, resolve, or hide flagged listings | C, D |
| 6. Manage categories, campus zones, approved domains, and aggregate metrics | A, B |
| 7. Manage infrastructure, backups, and restricted operational settings | A |

## Notes

- No monetary, credit, or convertible reward is offered; participation is practical community sharing.
- A lender acceptance locks the listing to one borrower, preventing double-booking.
- Pickup coordination uses an agreed campus zone and optional time window; it does not expose a live location or require real-time chat.
- Before launch, approve the pilot campus, allowed email domains, campus zones, prohibited items, privacy/acceptable-use notices, retention periods, and safety escalation contact.
