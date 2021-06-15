class CaseContactPresenter < BasePresenter
  attr_accessor :case_contacts

  def initialize(case_contacts)
    @case_contacts = case_contacts
  end

  def casa_cases
    @casa_cases ||= policy_scope(org_cases).group_by(&:id).transform_values(&:first)
  end

  def display_case_number(casa_case_id)
    "#{casa_cases[casa_case_id].decorate.transition_aged_youth_icon} #{casa_cases[casa_case_id].case_number}"
  end

  def boolean_select_options
    [
      [I18n.t("common.yes_text"), true],
      [I18n.t("common.no_text"), false]
    ]
  end

  private

  def org_cases
    CasaOrg.includes(:casa_cases)
      .references(:casa_cases)
      .find_by(id: current_user.casa_org_id)
      .casa_cases.includes(:case_contacts)
  end
end
