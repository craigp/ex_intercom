use Mix.Config
alias Dogma.Rule

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: [
    # %Rule.PipelineStart{enabled: false},
    %Rule.InfixOperatorPadding{enabled: false},
    # %Rule.TrailingBlankLines{enabled: false},
    # %Rule.SpaceMissingAfterComma{enabled: false}
  ]
