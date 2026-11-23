# Business Logic

> Development of a Web-based Student Equipment and Lab Tool Sharing Platform using React, Node.js, and Supabase for university students

- Allowed Platforms: Web, Android

## Project Details

- Company/Startup/Team Name: VisiCore
- Project Code Name: geardrop
- Project Short Code: GD
- Short Description: A community-powered sharing board where students lend and borrow spare calculators, chargers, lab tools, and adapters on campus without monetary rewards.
- Long Description: GearDrop enables students within a campus or department to share everyday academic and lab equipment—such as scientific calculators, extension cords, lab kits, and adapters—through location-pinned, time-limited availability posts. Rather than relying on external vendors or financial incentives, the platform connects peers for practical, low-friction borrowing and returning while protecting user privacy.

## User Levels

> Note: Modify/rename the list of users based on the actual users that you expect to use the system.

| User Level              | Description |
| ----------------------- | ----------- |
| A. System Administrator | Maintains/overrides system/server configurations and performs regular backups. |
| B. Administrator        | Manages the general settings of the system and generates periodic system analytics and reports. |
| C. Moderator            | Reviews flagged listings or reports and applies community-guideline hits when rules are violated. |
| D. Contributor          | Authenticated students who post available items, request to borrow items, and coordinate campus meetups. |
| E. Guest                | Users who do not log in, but view limited contents on the app/web. |

## System Requirements

1. The app shall allow the users to authenticate using Google Sign-In integration.
2. The app shall allow Contributors to create, update, and close time-limited, location-pinned item availability listings (such as calculators, chargers, and lab tools).
3. The app shall allow Guests and Contributors to browse and filter currently available items by category and campus location.
4. The app shall allow Contributors to send borrow requests and coordinate pickup/return status updates for an active listing.
5. The app shall allow Contributors to mark shared items as borrowed, returned, or expired so availability stays accurate.
6. The app shall allow Contributors and Moderators to flag inappropriate, unsafe, or non-compliant listings for review.
7. The app shall allow Moderators and Administrators to manage guideline-hit actions, active listings, and system settings.

## Required Solution Layers

1. Security and privacy by design. Data Privacy Act compliance, location protection, retention limits, no per-user trails, aggregation thresholds, and consent for any data resale.

## MVP Features and Access

> See the User Levels table for reference.

| Feature                                                        | Access      |
| -------------------------------------------------------------- | ----------- |
| 1. Browse public available item listings and campus locations  | A,B,C,D,E   |
| 2. Sign in with Google and manage basic profile/session        | A,B,C,D     |
| 3. Post, edit, and expire time-limited item availability listings| A,B,C,D     |
| 4. Request to borrow an item and update borrow/return status   | A,B,C,D     |
| 5. Flag listings and apply community-guideline hits            | A,B,C       |
| 6. View basic aggregate usage metrics and manage categories     | A,B         |
| 7. Manage system configuration and database backups            | A           |

## Notes
- No monetary, credit, or convertible rewards are offered; participation is driven by practical community sharing.
- Listings are time-limited and use coarse/safe campus location context rather than continuous personal tracking.
- Moderation uses community-guideline hits rather than visible reputation scores.
- Keep scope strictly focused on the MVP to support fast delivery.