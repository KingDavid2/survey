# frozen_string_literal: true

class SurveyPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.platform_admin?
  end

  def show?
    @user.platform_admin?
  end

  def create?
    @user.platform_admin?
  end

  def new?
    create?
  end

  def update?
    @user.platform_admin?
  end

  def edit?
    update?
  end

  def destroy?
    @user.platform_admin?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
