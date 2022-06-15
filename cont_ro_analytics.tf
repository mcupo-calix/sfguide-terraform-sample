terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.35.0"
    }
  }
}

provider "snowflake" {
  alias = "account_admin"
  role  = "ACCOUNTADMIN"
}

###########################################################################
#  List of schemas in databases that we need to manage at the schema level
###########################################################################

variable "analytics_schemas" {
  type    = set(string)
  default = ["DATA_OPS",
      "DATA_QUALITY",
      "EDW",
      "EDW_CE",
      "JIRA",
      "MULESOFT",
      "QLIK_REPORTS",
      "SOP",
      "STG",
      "SUPPLIER"]
}

###########################################################################
#  List of schemas in databases that we need to manage at the schema level
###########################################################################

resource snowflake_database_grant grant {
  database_name = "ANALYTICS"

  privilege = "USAGE"
  roles     = ["CONT_RO_ANALYTICS"]
  
  enable_multiple_grants = true
}

resource snowflake_table_grant grant {
  for_each = var.analytics_schemas
  
  database_name = "ANALYTICS"
  schema_name   = each.value

  privilege = "SELECT"  
  roles     = ["CONT_RO_ANALYTICS"]
  
  on_future         = true
  enable_multiple_grants = true
}