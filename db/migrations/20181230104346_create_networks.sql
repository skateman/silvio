-- +micrate Up
CREATE TABLE IF NOT EXISTS "networks" (
  "id" integer NOT NULL PRIMARY KEY,
  "name" varchar NOT NULL,
  "address" varchar NOT NULL,
  "netmask" varchar NOT NULL,
  "created_at" datetime NOT NULL,
  "updated_at" datetime NOT NULL
);


-- +micrate Down
DROP TABLE "networks";
