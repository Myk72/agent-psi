# Rule Definitions and Validation

This directory collects rules from the MeTTa file, validates their structure and STV fields, and returns the rules that pass validation. This enables newly reasoned rules to be verified for consistent structure.

## Contents
- rule.metta: Source of rule declarations.
- validate_rule.py: Parser/validator that loads rules, checks structure and STV fields, and reports valid rules.

## Usage
- Run validation (from repository root): python3 rule/validate_rule.py

## Expected Rule Shape
Rules are expected to follow this structure:

- (: Rule <id>
    (TTV <int>)
    (STV <float> <float>)
    (Complexity <int>)
    (IMPLICATION
      (AND
        (Context (STV <float> <float>) (AND <contexts...>))
        (Action (SEQ_AND <actions...>)))
      (Goal (STV <float> <float>) (AND <goals...>))))

## Notes
- STV fields must be of the form (STV <float> <float>).
- The validator reports per-rule issues and totals valid rules.
- Only rules that conform to the expected structure are considered valid.
