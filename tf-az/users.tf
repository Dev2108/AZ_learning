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

