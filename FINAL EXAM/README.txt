

 Overview

This project models a distributed beverage delivery and sales system across two operational nodes:
 BRANCHDB_A and BRANCHDB_B. It demonstrates how Oracle SQL can be used to manage deliveries,
 synchronize data across branches, and ensure transactional integrity in a multi-node setup. 
The system includes table creation, data fragmentation horizontal, remote access, 
distributed joins, aggregation strategies, two-phase commit (2PC) logic, and business rule enforcement via triggers.

 QA1. Table Fragmentation and Recombination
Two delivery tables — Delivery_A and Delivery_B : Are created on separate nodes to represent regional delivery records.
 Each table captures essential delivery details: DeliveryID, BatchID (production lot), DistributorID (logistics partner),
 DateDelivered, and Quantity (units shipped).
Delivery_C serves as a unified table that recombines data from both branches for centralized analysis.

QA2. Data Population
Each node receives ≤5 sample rows to simulate real beverage shipments.
SYSDATE is used for timestamping deliveries, ensuring realistic tracking.
Delivery_C is populated with the same records to validate recombination logic.yu

QA3. Database Link Creation
Secure links are created between Node_A and Node_B using `CREATE DATABASE LINK`.
These links enable remote queries and distributed operations.
Authentication is handled via `CONNECT TO` with a sample password and service name 'XEPDB1'.

QA4. Validation via COUNT and Checksum
'SELECT COUNT(*)' confirms row counts across nodes.
`SUM(MOD(DeliveryID, 97))` is used as a checksum to verify data consistency.
 Delivery_ALL is assumed to be a union view combining Delivery_A and Delivery_C.

QA5. Remote SELECT
A remote query retrieves up to 5 rows from Delivery_C using `ROWNUM <= 5`.
This tests the database link and confirms visibility of remote delivery data.

QB6. Distributed Join
A join is performed between Delivery_A and a remote Invoice table using `JOIN Invoice@proj_link`.
This simulates reconciliation between deliveries and sales invoices across branches.

QB7. Aggregation Techniques
**Serial Aggregation**: Standard `GROUP BY` without performance hints.
**Parallel Aggregation**: Oracle hints `/*+ PARALLEL(...) */` are used to optimize performance across nodes.
Execution plans are analyzed using `EXPLAIN PLAN` and `DBMS_XPLAN.DISPLAY`.

QB8. Two-Phase Commit (2PC)
 A PL/SQL block inserts one row locally and another remotely, then commits.
This simulates atomic distributed transactions for synchronized delivery updates.

QB9. Simulated Failure
A second PL/SQL block induces a failure (e.g., missing table) to test in-doubt transaction handling.
`DBA_2PC_PENDING` is queried to check for unresolved distributed transactions.

QB10. Business Limit Alert (Function + Trigger)

A custom PL/SQL function is created to check whether a delivery exceeds a predefined quantity threshold (e.g., 1000 units).
A trigger is attached to the Delivery table to automatically invoke this function before insert or update.
If the quantity exceeds the limit, the trigger raises an exception to prevent the transaction.
This enforces business rules and protects against over-budget deliveries, ensuring row-level safety and compliance.

Notes:
All code is written for Oracle SQL Developer.
Replace credentials and service names with secure values in production.
Ensure database links are properly configured before executing remote operations.

Learning Objectives

Understand how distributed databases support regional delivery operations.
Practice remote querying and joining across branches.
Explore performance tuning with parallel hints.
Implement and troubleshoot two-phase commit logic.
Apply business rule enforcement using PL/SQL functions and triggers.

Author

BY 
UWANYIRIGIRA CLAUDINE
REG:224020280


