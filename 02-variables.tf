variable "default_tag" {
  type = map(string)
  default = {
    CostCenter = "PH2660"
  }
}

variable "env_name" {
  type = string
}

variable "import_storage_account" {
  type = string
}

# name of the file shares. 
variable "import_fileshares" {
  type = list(string)
}

# group name 
variable "group_name" {
  type = string
}

variable "group1_name" {
  type = string
}

# group location 
variable "group_location" {
  type = string
}

variable "group1_location" {
  type = string
}

#VNET variable
variable "vnet_name" {
  type = string
}

variable "subnet1" {
  type = string
}

variable "subnet2" {
  type = string
}

variable "subnet3" {
  type = string
}

variable "subnet4" {
  type = string
}

variable "routetable" {
  type = string
}

# Resources Tags 
variable "group_tag" {
  type = map(any)
  default = {
    Department    = "ia"
    Application   = "network"
    BusinessOwner = "JOHN_METHOT@DFCI.HARVARD.EDU"
    BusinessUnit  = "0100"
    CostCenter    = "PH2660"
    Criticality   = "Non-Production"
    Environment   = "Non-Production"
    Entity        = "DFCI"
    Description   = "Resource Group for Networking"
    ManagedBy     = "Cloud Platform Services - phs"
  }
}

variable "vnet_tag" {
  type = map(any)
  default = {
    Department    = "ia"
    Application   = "network"
    BusinessOwner = "JOHN_METHOT@DFCI.HARVARD.EDU"
    BusinessUnit  = "0100"
    CostCenter    = "PH2660"
    Criticality   = "Non-Production"
    Environment   = "Non-Production"
    Description   = "VNET for DFCI Non Prod subscription to E2/Express  Route"
    ManagedBy     = "Cloud Platform Services - phs"
  }
}



