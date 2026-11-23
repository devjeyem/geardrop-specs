# Business Logic v1.1 — Proposed MVP

**Status:** Proposal — requires product-owner and campus-policy approval.

> Development of a web-first campus equipment-sharing platform using React, Node.js, and Supabase for verified university students.

## 1. Product positioning

GearDrop is a **privacy-first campus sharing board** that helps verified students borrow small academic and lab essentials—such as calculators, chargers, adapters, and lab tools—from nearby peers when they need them.

It is not a marketplace, rental service, rewards system, or asset-management system. Its promise is simple: **find a currently available item, request it, and close the handoff clearly.**

### Pilot focus

- **Audience:** students with an approved university Google account.
- **Place:** one named pilot campus, with a controlled list of campus zones.
- **Items:** low-risk, portable academic and lab-support equipment. The launch policy must list excluded items; dangerous, regulated, or high-value equipment must not be listed.
- **Platform:** responsive web application first. Android is deferred until the web pilot proves the core journey.
- **Exchange model:** no payments, credits, deposits, rewards, or convertible value.

## 2. What v1.0 establishes, and what must be completed

| Area | v1.0 status | v1.1 proposal / decision needed |
| --- | --- | --- |
| Primary user and value | Established, but broad | Pilot one campus and verified students; optimize the borrow-request-return journey. |
| Platform | Says web-based, but permits Web and Android | Ship web first; treat Android as post-pilot scope. |
| Eligibility | Google Sign-In named, eligibility unspecified | Permit only approved university Google domains; an Administrator manages the allow-list. |
| Listing lifecycle | Create, edit, close, expire are named | Define `available`, `requested`, `borrowed`, `returned`, `closed`, and `expired`; only one active borrower per listing. |
| Borrow request | Request and status updates are named | Add accept, decline, and cancel. A lender acceptance locks the item to that request. |
| Pickup coordination | Mentioned, no privacy boundary | Use a campus-zone pickup note and optional time window; do not expose precise live location or personal contact details. |
| Item safety | Item examples only | Require category, title, condition, and pickup zone; publish a prohibited-items policy before launch. |
| Guest access | Guests browse "campus locations" | Guests may see an anonymized, limited listing catalogue; exact zones and all request actions require sign-in. |
| Moderation | Flagging and guideline hits named | Give Contributors flagging and Moderators a queue with resolve/dismiss actions. Keep guideline-hit rules internal; no public reputation score. |
| Privacy and retention | Intent stated, controls unspecified | Define minimum data, role access, aggregation, deletion/retention periods, and consent before collecting data. |
| Success criteria | Missing | Measure active listings, fulfilled requests, return closure, time to first request, and safety/moderation incidents using aggregate metrics only. |

## 3. Project details

- **Company/Team:** VisiCore
- **Project code name:** GearDrop
- **Short code:** GD
- **Short description:** A non-monetary sharing board for verified students to lend and borrow small academic and lab essentials within a pilot campus.
- **Long description:** GearDrop lets verified students post time-limited availability for spare academic and lab equipment, find relevant nearby items by category and campus zone, request a borrow, and record the item’s return. It deliberately uses coarse campus locations and minimal coordination details instead of continuous location tracking, payments, or public reputation.

## 4. Users and access

| User | Purpose | MVP permissions |
| --- | --- | --- |
| Guest | Evaluate whether GearDrop is useful | Browse limited, anonymized available listings by category; sign in to see exact pickup zones or act. |
| Contributor | Lend or borrow an item | Manage own profile, listings, requests, and borrow/return confirmations; flag a listing. |
| Moderator | Keep the board safe and useful | Review flags; resolve or dismiss a report; hide a listing when policy requires it. |
| Administrator | Run the pilot | Manage categories, campus zones, approved email domains, and moderator access; view aggregate metrics. |
| System Administrator | Maintain the service | Manage infrastructure, backup, recovery, and restricted operational settings. No routine content moderation. |

## 5. Core MVP journey

1. A student signs in with an approved university Google account and accepts the community and privacy notice.
2. The lender posts an item with category, short title, condition, pickup zone, available-until time, and optional handoff window.
3. A guest or Contributor browses available listings by category and coarse campus zone. The Contributor signs in to request an item.
4. The borrower sends one request with an optional short handoff note. The lender accepts or declines it.
5. On acceptance, the listing becomes `borrowed`; the two participants see the agreed pickup zone/window and status controls.
6. Either participant marks the item returned; the other confirms it. The listing then closes or becomes available again only if the lender explicitly reposts it.
7. Any signed-in user can flag a listing. A Moderator resolves the report and may hide the listing.

**Lifecycle rule:** A listing automatically becomes `expired` at its available-until time unless it is already `borrowed`. A borrower cannot request an expired, hidden, closed, or already requested listing. This prevents silent double-booking and stale availability.

## 6. MVP feature list

| # | Feature | Users | Acceptance boundary |
| --- | --- | --- | --- |
| 1 | University Google sign-in and session | Contributors and staff roles | Only approved email domains can create a Contributor session. |
| 2 | Listing board | Everyone | Show available, non-hidden listings; guests see no lender identity or exact pickup details. |
| 3 | Create and manage a listing | Contributors | Require category, title, condition, campus zone, and expiry; owner can edit or close only their own listing. |
| 4 | Browse and filter | Everyone | Filter available listings by category and campus zone; no map, live location, or recommendation engine. |
| 5 | Request and decision | Contributors | One active request per item; lender can accept/decline, requester can cancel; acceptance locks the listing. |
| 6 | Borrow and return status | Request participants | Record `borrowed`, return claimed, and return confirmed; preserve an auditable minimal status history. |
| 7 | Report and moderate | Contributors, Moderators | Contributors flag; Moderators resolve/dismiss and hide when needed. |
| 8 | Pilot administration | Administrators, System Administrators | Manage categories, zones, approved domains, roles, and aggregate operational metrics. |

## 7. Explicitly out of scope for MVP

- Native Android application.
- Payments, fees, deposits, credits, rewards, or escrow.
- Ratings, public reputation scores, follower systems, or social feeds.
- Real-time chat, calls, SMS, email notifications, or push notifications; use status pages and the existing sign-in session only.
- Maps, GPS, continuous location history, or precise location sharing.
- Inventory ownership verification, barcode scanning, institutional asset tracking, or maintenance scheduling.
- Multi-campus federation, external marketplace integration, delivery, or shipping.
- Recommendation, matching, or AI features.
- Advanced reporting beyond privacy-safe aggregate pilot metrics.

## 8. Privacy, safety, and operational requirements

1. Collect only the account identity needed to verify campus eligibility, basic profile display information, listing data, request/status records, moderation records, and aggregate metrics.
2. Store campus zones from an administrator-controlled list; never collect background location or display a precise pickup coordinate.
3. Limit listing visibility to the pilot campus. Show the minimum identity/contact information required for an accepted request; the exact display policy needs approval before launch.
4. Publish acceptable-use, prohibited-items, conduct, and incident-escalation rules before the first listing goes live.
5. Define retention periods for expired listings, completed requests, flags, audit records, backups, and account deletion. Retention must be approved against the applicable Data Privacy Act obligations.
6. Do not sell, share, or reuse personal data for a new purpose without explicit, recorded consent. Aggregate metrics must meet a documented minimum group-size threshold.
7. Keep moderation outcomes and operational analytics out of public user profiles.

## 9. Release gates and pilot measures

### Must be decided before implementation

1. Pilot campus and the approved Google email domain(s).
2. The controlled list of pickup zones and excluded/prohibited item categories.
3. The required wording for consent, acceptable use, privacy notice, and disclaimer of item condition/availability.
4. Whether accepted participants can see names only, names plus university email, or another approved contact channel.
5. Data-retention periods and the aggregate-metric threshold.
6. Who serves as Moderator, Administrator, System Administrator, and the escalation contact for safety reports.

### MVP success measures

- Number of active listings and fulfilled borrow requests per week.
- Percentage of accepted requests closed as returned.
- Median time from listing creation to first request.
- Number and resolution time of flags, measured in aggregate.
- Number of stale, expired, or disputed listings.

Do not set launch targets until a pilot owner confirms the campus size and expected availability.

## 10. Requirements traceability

| v1.0 requirement | Proposed MVP treatment |
| --- | --- |
| Google Sign-In | Feature 1, with approved-domain eligibility. |
| Time-limited, location-pinned listings | Feature 3, using controlled coarse campus zones. |
| Browse and filter | Feature 4. |
| Borrow requests and coordination | Feature 5, with a short handoff note and window rather than live chat. |
| Borrowed, returned, expired states | Feature 6 and the lifecycle rule. |
| Flagging and guideline hits | Feature 7; internal moderation only. |
| Manage listings, settings, and reports | Feature 8, limited to pilot operation. |
| Privacy by design | Section 8; detailed controls remain a required pre-launch decision. |
