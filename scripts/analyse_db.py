import os

import psycopg2
import typer
from psycopg2.extras import RealDictCursor
from rich.console import Console
from rich.table import Table

console = Console()
app = typer.Typer()

DB_HOST = os.getenv("DATABASE_HOST")
DB_PORT = os.getenv("DATABASE_PORT")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER") 
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")


def get_connection() -> None:
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )


@app.command()
def query_all_users()-> None:
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute('SELECT * FROM "user";')
            rows = cur.fetchall()
            table = Table(title="All Users")
            table.add_column("user_id", justify="right")
            table.add_column("username")
            table.add_column("email")
            table.add_column("created_at")
            table.add_column("last_login", justify="right")

            for row in rows:
                table.add_row(
                    str(row["user_id"]),
                    row["username"],
                    row["email"],
                    str(row["created_at"]),
                    str(row["last_login"]) if row["last_login"] else ""
                )
            console.print(table)


@app.command()
def query_open_dialogs_for_user(user_id: int)-> None:
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(
                """
                SELECT dialog_id, title, status
                FROM dialog
                WHERE user_id = %s
                  AND status = 'open'
                """,
                (user_id,)
            )
            rows = cur.fetchall()
            table = Table(title=f"Open dialogs for user_id={user_id}")
            table.add_column("dialog_id", justify="right")
            table.add_column("title")
            table.add_column("status")

            for row in rows:
                table.add_row(str(row["dialog_id"]), row["title"], row["status"])
            console.print(table)


@app.command()
def count_messages_per_user() -> None:
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            query = """
                SELECT u.user_id, u.username, COUNT(m.message_id) AS message_count
                FROM "user" u
                JOIN dialog d ON u.user_id = d.user_id
                JOIN message m ON d.dialog_id = m.dialog_id
                WHERE m.sender_type = 'user'
                GROUP BY u.user_id, u.username
                ORDER BY message_count DESC;
            """
            cur.execute(query)
            rows = cur.fetchall()
            table = Table(title="Message Count per User")
            table.add_column("user_id", justify="right")
            table.add_column("username")
            table.add_column("message_count", justify="right")

            for row in rows:
                table.add_row(str(row["user_id"]), row["username"], str(row["message_count"]))
            console.print(table)



if __name__ == "__main__":
    app()