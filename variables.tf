variable "is_global" {
  description = "Is the resource considered a global resource"
  type        = bool
  default     = false
}

variable "display_name" {
  description = "The display name of the action group."
  type        = string

  validation {
    condition     = 0 < length(var.display_name) && length(var.display_name) < 13
    error_message = "Expected length of display_name to be in the range (1 - 12), got ${var.display_name}"
  }
}

variable "name" {
  description = "The name tokens used to construct the resource name and tags."
  type = object({
    contact     = string
    environment = string
    instance    = optional(number)
    program     = optional(string)
    repository  = string
    workload    = string
  })
}

variable "optional_tags" {
  default     = {}
  description = "A map of additional tags for the resource."
  type        = map(string)
}

variable "resource_group" {
  description = "The resource group to deploy resources into"

  type = object({
    location = string
    name     = string
  })
}
