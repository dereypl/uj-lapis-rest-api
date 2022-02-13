schema = require "lapis.db.schema"

import create_table, types from schema

create_table "products", {
  {"id", types.serial}
  {"name", types.varchar}
  {"category_id", types.serial}

  "PRIMARY KEY (id)"
}

create_table "categories", {
  {"id", types.serial}
  {"name", types.varchar}

  "PRIMARY KEY (id)"
}
