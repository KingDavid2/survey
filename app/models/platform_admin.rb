# frozen_string_literal: true

# Represent a platform admin user
class PlatformAdmin < User
  ROLE = 'PlatformAdmin'
  default_scope { where role: ROLE }
end
