# frozen_string_literal: true

# Concern to role
module Roleable
  extend ActiveSupport::Concern

  def platform_admin?
    role == PlatformAdmin::ROLE
  end

  def member?
    role == Member::ROLE
  end
end
