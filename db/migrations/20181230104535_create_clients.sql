-- +micrate Up
CREATE TABLE IF NOT EXISTS "clients" (
  "id" integer NOT NULL PRIMARY KEY,
  "name" varchar NOT NULL,
  "token" varchar NOT NULL,
  "address" varchar NOT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL,
  "network_id" integer NOT NULL REFERENCES "networks"("id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX "index_clients_on_token" ON "clients" ("token");

-- +micrate Down
DROP TABLE "clients";
