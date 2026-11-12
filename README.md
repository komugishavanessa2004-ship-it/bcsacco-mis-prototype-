# Tukolerewamu Farmers' SACCO: Management Information System (Prototype)

BIT 2102 Management Information Systems and Development, Semester I, November 2026.

Group members: [Name 1], [Name 2], [Name 3]

## What it is
A browser-based prototype MIS for a village SACCO. It integrates membership, savings, loans, repayments and
management reporting, with views for different user levels.

## How to run
No installation needed. Open `index.html` in any modern browser.

## Sign in
The app opens as a read-only page showing every screen (Dashboard, Savings, Loans, Members, Audit) with no forms or buttons for recording data. The header has "Log in as Teller / Loans officer / Manager / Member" buttons; pressing one opens the login page for that role. After logging in, the user sees only the screens and actions for their role. Prototype logins, all with password `sacco123`: `teller1`, `officer1`, `manager1`, `nakato` (member), or any Member ID such as `M002`. Use Sign out (top right) to switch user.

## Roles
| Role | Level | Can do |
|---|---|---|
| Teller | Operational | Record deposits/withdrawals, register members |
| Loans officer | Operational | Submit loan applications, record repayments (cash, MTN MoMo, Airtel Money) |
| Manager | Tactical/Strategic | Dashboard (portfolio at risk, arrears), approve or reject loans, audit trail |
| Member | External | View own savings, loans and transactions |

## Business rules
- Withdrawals cannot exceed the member's savings balance.
- A loan cannot exceed 3 times the member's savings.
- Interest is 12% a year, flat; instalment = total repayable / months.
- A loan is overdue when its next due date has passed and a balance remains.
- Every sensitive action is written to the audit trail.

## Structure
```
sacco-mis/
  index.html        page layout
  css/style.css     styling (light and dark mode)
  js/app.js         data, business rules and screens
  database/schema.sql  reference relational schema (matches the ERD)
```

## Limitations
Data is held in memory with sample records and resets on reload. Sign-in is simulated in the browser (a shared demo password, no server). A full build would use
a backend and the database in `database/schema.sql`, with password hashing and daily backups.
