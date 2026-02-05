CREATE TABLE role
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    CHECK ( name IN ('admin', 'manager', 'developer') )
);

CREATE TABLE users
(
    id        SERIAL PRIMARY KEY,
    user_name VARCHAR(50)         NOT NULL,
    email     VARCHAR(100) UNIQUE NOT NULL,
    role_id   INT REFERENCES role (id) ON DELETE RESTRICT
);

CREATE TABLE projects
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    status      VARCHAR(20) DEFAULT 'not active',
    CHECK ( status IN ('active', 'not active') ),
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks
(
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(50) NOT NULL,
    description TEXT,
    user_id     INT         REFERENCES users (id) ON DELETE SET NULL,
    project_id  INT REFERENCES projects (id) ON DELETE CASCADE,
    status      VARCHAR(20) default 'new',
    CHECK ( status IN ('new', 'in progress', 'done')),
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments
(
    id         BIGSERIAL PRIMARY KEY,
    task_id    INT REFERENCES tasks (id) ON DELETE CASCADE NOT NULL,
    user_id    INT REFERENCES users (id) ON DELETE CASCADE NOT NULL,
    content    TEXT                                        NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE changeHistory
(
    id         SERIAL PRIMARY KEY,
    task_id    INT REFERENCES tasks (id) ON DELETE CASCADE,
    user_id    INT REFERENCES users (id) ON DELETE SET NULL,
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_roles_name ON role (name);
CREATE INDEX idx_users_name ON users (user_name);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_projects_name ON projects (name);
CREATE INDEX idx_projects_status_active ON projects (status) WHERE status = 'active';
CREATE INDEX idx_projects_status_not_active ON projects (status) WHERE status = 'not active';
CREATE INDEX idx_tasks_title ON tasks (title);
CREATE INDEX idx_tasks_user ON tasks (user_id);
CREATE INDEX idx_tasks_project ON tasks (project_id);
CREATE INDEX idx_tasks_status_new ON tasks (status) WHERE status = 'new';
CREATE INDEX idx_tasks_status_in_progress ON tasks (status) WHERE status = 'in progress';
CREATE INDEX idx_tasks_status_done ON tasks (status) WHERE status = 'done';
CREATE INDEX idx_comments_task ON comments (task_id);
CREATE INDEX idx_comments_user ON comments (user_id);
CREATE INDEX idx_changeHistory_task ON changeHistory (task_id);
CREATE INDEX idx_changeHistory_user ON changeHistory (user_id);


