name "apt"
description "Role applied to APT repositories"

default_attributes(
  :accounts => {
    :users => {
      :apt => {
        :status => :role,
        :members => [
          :tomh, :grant
        ]
      }
    }
  }
)

run_list(
  "recipe[apt::repository]"
)
