# Dotfiles Architecture & Design Principles

## Vision

This repository bootstraps a development environment from a fresh system.
It should be understandable, reproducible, deterministic, idempotent,
composable, and easy to extend.

The goal is to build something that remains understandable five years from now.
Whenever there is a choice between cleverness and simplicity, choose simplicity.

## Core philosophy

### One responsibility

Each component should have a clear purpose. Configuration, software provisioning,
system changes, and orchestration are separate responsibilities.

Keep their boundaries explicit. A component should not take over another
responsibility simply because it can.

### Ordinary files first

Prefer configuration that can be opened, read, and edited directly.
Someone exploring the repository should not need to learn another framework
before understanding what it does.

Introduce a DSL, generator, template engine, or abstraction only when it solves
a concrete problem and reduces the total maintenance cost.

### One source of truth

The repository defines shared configuration. Applying it should preserve a clear
relationship between the versioned files and the active configuration.

Machine-specific state and private values stay outside the shared configuration.
Their boundaries should be explicit so that local needs do not create competing
sources of truth.

### Declarative over imperative

Describe the desired state wherever possible. Use procedural steps when the
system requires an action that cannot be expressed as configuration.

Keep those actions small and explicit. Configuration should remain readable
without tracing installation logic.

### Reproducibility and determinism

The same declared inputs should lead to the same intended configuration.
Dependencies and local overrides should be visible rather than inferred from
an undocumented machine state.

Where inputs are intentionally allowed to change, make that choice explicit.
A reproducible setup should make it possible to understand why two machines differ.

### Idempotency

Repeating setup should converge on the desired state. It should not accumulate
duplicate entries, repeat destructive actions, or break an existing setup.

An interrupted setup should be safe to run again. Conflicts should be reported
clearly rather than resolved by silently replacing user data.

### Composability

Parts should be understandable and usable independently. Keep dependencies
explicit and limit coupling between unrelated components.

Orchestration coordinates those parts. It should contain as little knowledge
of their internal behavior as possible.

### Replaceable tools

The architecture describes responsibilities rather than a permanent set of tools.
A tool can be replaced when needs change without redefining the whole system.

Avoid coupling unrelated configuration to one application's conventions.
Choose tools for the responsibility they serve and the maintenance they require.

## Organization

Separate desired configuration, procedural actions, and orchestration.
Keep each concern easy to locate and change without affecting unrelated parts.

Structure should reflect the configuration being managed. Use descriptive names,
keep nesting shallow, and avoid introducing layers solely for organizational symmetry.

Documentation has distinct roles: installation instructions explain how to start,
operational notes preserve useful reminders, and architecture explains the design.
Keep implementation details close to the component they describe.

## Automation

Automation should reduce maintenance and manual intervention. Its behavior should
be explicit, inspectable, and easy to debug.

Check prerequisites and conflicts before applying dependent changes. Failures
should identify what stopped and leave enough information to continue safely.

Do not hide complexity behind automation. If understanding an automated step
requires more work than performing it manually, simplify the design.

## Design decisions

Before adding a component or changing a boundary, ask:

- Does it solve a current problem?
- Does it duplicate an existing responsibility?
- Does it add a dependency or abstraction that earns its maintenance cost?
- Can someone understand its purpose and behavior in minutes?
- Does it make failures easier to diagnose?
- Can it be changed or removed without disturbing unrelated components?

Prefer the smallest design that meets the need. Add complexity when there is
evidence for it, rather than anticipating every possible future requirement.

## Long-term goal

A fresh system should become a configured development environment through one
clear entry point, with minimal manual intervention.

As tools and preferences evolve, the repository should remain readable,
maintainable, and easy to reason about. The principles should outlast the
individual tools used to implement them.
