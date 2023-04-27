# frozen_string_literal: true

class Member < User
  ROLE = 'Member'
  default_scope { where role: ROLE }
end
