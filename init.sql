CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login TIMESTAMP
);

CREATE TABLE session (
    session_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMP,
    ip_address VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE
);

CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE
);

CREATE TABLE llm (
    llm_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    version VARCHAR(50),
    configuration_details TEXT
);

CREATE TABLE dialog (
    dialog_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    llm_id INTEGER NOT NULL,
    title VARCHAR(200),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP,
    status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES "user"(user_id) ON DELETE CASCADE,
    FOREIGN KEY (llm_id) REFERENCES llm(llm_id) ON DELETE CASCADE
);

CREATE TABLE dialog_project (
    dialog_id INTEGER NOT NULL,
    project_id INTEGER NOT NULL,
    PRIMARY KEY (dialog_id, project_id),
    FOREIGN KEY (dialog_id) REFERENCES dialog(dialog_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES project(project_id) ON DELETE CASCADE
);

CREATE TABLE message (
    message_id SERIAL PRIMARY KEY,
    dialog_id INTEGER NOT NULL,
    sender_type VARCHAR(50),
    content TEXT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (dialog_id) REFERENCES dialog(dialog_id) ON DELETE CASCADE
);


INSERT INTO "user"(username, email, password_hash)
VALUES
('alice', 'alice@example.com', 'hash_alice'),
('bob', 'bob@example.com', 'hash_bob'),
('charlie', 'charlie@example.com', 'hash_charlie');

INSERT INTO session(user_id, ip_address)
VALUES
(1, '192.168.1.10'),
(2, '192.168.1.11'),
(3, '192.168.1.12');

INSERT INTO project(user_id, project_name, description)
VALUES
(1, 'Chatbot Project', 'A project to develop a chatbot'),
(2, 'NLP Research', 'Exploring advanced NLP techniques'),
(3, 'Test Project', 'Just testing the database');

INSERT INTO llm(model_name, version, configuration_details)
VALUES
('gpt-3.5-turbo', '3.5', 'Default config'),
('bert-base-uncased', '1.0', 'Default config'),
('distilbert-base-uncased', '2.0', 'Fine-tuned config');

INSERT INTO dialog(user_id, llm_id, title, status)
VALUES
(1, 1, 'First Chat with GPT-3.5', 'open'),
(1, 2, 'Experiment with BERT', 'closed'),
(2, 3, 'Trying DistilBERT', 'open');

INSERT INTO dialog_project(dialog_id, project_id)
VALUES
(1, 1),
(2, 1),
(3, 2);

INSERT INTO message(dialog_id, sender_type, content)
VALUES
(1, 'user', 'Hello, GPT-3.5!'),
(1, 'llm', 'Hello, how can I help you?'),
(2, 'user', 'Testing BERT model'),
(2, 'llm', 'BERT is not exactly a generative model.'),
(3, 'user', 'DistilBERT is smaller, right?'),
(3, 'llm', 'Yes, DistilBERT is a smaller version of BERT.');
