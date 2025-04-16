variable "users_by_group" {
  type = map(list(string))
  default = {
    developer = [
      "developer1@prashanttripathimindfiresol.onmicrosoft.com",
      "developer2@prashanttripathimindfiresol.onmicrosoft.com"
    ],
    qa = [
      "sr_qa@prashanttripathimindfiresol.onmicrosoft.com"
    ]
  }
}

locals {
  # Read and decode the CSV file
  csv_data = file("${path.module}/users.csv")
  users = csvdecode(local.csv_data)

  # Extract unique groups from the CSV data
  groups = distinct([for user in local.users : user.group])

  # Create a map of groups to their respective emails from the CSV
  csv_users_by_group = {
    for group in local.groups :
    group => [for user in local.users : user.email if user.group == group]
  }

  # Combine keys from both the predefined variable and CSV data
  all_groups = toset(concat(
    keys(var.users_by_group),
    keys(local.csv_users_by_group)
  ))

  # Merge the user lists for each group
  users_by_group = {
    for group in local.all_groups :
    group => concat(
      lookup(var.users_by_group, group, []),
      lookup(local.csv_users_by_group, group, [])
    )
  }
}

