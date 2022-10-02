# Tips

Having the go command will not stop the transaction from committing

set implicit_transaction (query option from tools) ==> 

In SQL Server, an implicit transaction is when a new transaction is implicitly started when the prior transaction completes, but each transaction is explicitly completed with a COMMIT or ROLLBACK statement. This is not to be confused with autocommit mode, where the transaction is started and ended implicitly

## When IMPLICIT_TRANSACTIONS is OFF

When your IMPLICIT_TRANSACTIONS setting is OFF, the above statements perform transactions in autocommit mode. That is, they start and end the transaction implicitly.

So it’s like having an invisible BEGIN TRANSACTION statement and an invisible COMMIT TRANSACTION statement, all from the one statement.

In this case, you do not need to do anything to commit or rollback the transaction. It was already done for you.

## When IMPLICIT_TRANSACTIONS is ON

When your IMPLICIT_TRANSACTIONS setting is ON, the above statements behave slightly different.

When IMPLICIT_TRANSACTIONS setting is ON, the above statements get an invisible BEGIN TRANSACTION statement but they don’t get a corresponding COMMIT TRANSACTION statement.

This means that you need to explicitly commit or rollback the transaction yourself.

However, when the transaction mode is implicit, no invisible BEGIN TRANSACTION is issued if a transaction is already in progress.