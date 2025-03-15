
# Concept of DB: Yeat Another GPT Wrapper

It is a concept of database, which could potentially represent some service with LLM. 

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
  - [1. Create the `.env` file](#1-create-the-env-file)
  - [2. Start Postgres via Docker Compose](#2-start-postgres-via-docker-compose)
  - [3. Install Dependencies](#3-install-dependencies)
- [Usage](#usage)
  - [Running Commands](#running-commands)
  - [Available Commands](#available-commands)
  - [Recommended Order of Commands](#recommended-order-of-commands)
---

## Prerequisites

- [Docker](https://www.docker.com/) & [Docker Compose](https://docs.docker.com/compose/) installed
- Python 3.12+ installed
- [UV](https://github.com/astral-sh/uv) or a virtual environment tool of your choice

## Setup

### 1. Create the `.env` file

Create a `.env` file in the root directory of the project. This file should define the environment variables used by the Python script to connect to the database:

```bash
DATABASE_HOST=
DATABASE_PORT=
DATABASE_NAME=
DATABASE_USER=
DATABASE_PASSWORD=
```

### 2. Start DB via Docker Compose

```bash
docker compose up -d db
```

### 3. Install Dependencies

```bash
uv sync
```

## Usage

### Running Commands

To run any of the available commands, make sure your Postgres container is running, your .env is in place, and you are in the correct virtual environment (if applicable). Then execute:

```bash
uv run scripts/analyse_db.py [COMMAND]
```
### Available Commands

Below are the commands implemented in analyse_db.py:

1. **query-all-users**

Fetches and displays all users in the "user" table, showing user ID, username, email, creation date, and last login.

```bash
python scripts/analyse_db.py query-all-users
```

2. **query-open-dialogs-for-user [user_id]**

Shows all open dialogs for a specific user.

```bash
python scripts/analyse_db.py query-open-dialogs-for-user 1
```

3.  **count-messages-per-user**

Displays a table of users with the total number of messages sent by each user (based on the sender_type = 'user' condition).

```bash
python scripts/analyse_db.py count-messages-per-user
```


### Recommended Order of Commands

You can run these commands in any order; however, a common workflow might be:

- **query-all-users** – to see a list of all users.

-  **query-open-dialogs-for-user [user_id]** – to investigate open dialogs for a specific user you found in step 1.

- **count-messages-per-user** – to analyze message counts across all users.

