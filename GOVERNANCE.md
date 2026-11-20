# Governance

TurtleBridge is publicly developed and owner-led. The repository is public so its decisions, evidence, security practices, and limitations can be reviewed. Public visibility does not imply permission to modify the project.

## Decision authority

`@projectnextbuilds` is the project owner and final decision-maker. The owner is accountable for scope, architecture, security, releases, repository access, and public compatibility statements.

Changes to `main` must use a pull request, pass required automated checks, resolve review conversations, and preserve a linear history. Force pushes and branch deletion are prohibited. `CODEOWNERS` records ownership; before the first release, the solo-owner model uses automated gates and documented self-review rather than pretending that an independent approval occurred.

## Pre-release access policy

Until the first tagged release:

- the repository remains public and readable;
- write access is limited to the owner;
- pull request creation is limited to collaborators;
- unsolicited external pull requests are not accepted; and
- issues remain available as structured public feedback, not as an offer of repository access or a promise that work will be adopted.

This pause keeps the initial architecture and security boundaries coherent. The policy will be reviewed at the first tagged release. Any future contributor access will be granted deliberately, with least privilege, and can be removed when it is no longer needed.

## Change governance

Each pull request should have one primary outcome and record:

- the reason for the change and its linked issue when applicable;
- automated, manual, and hardware verification performed;
- meaningful tests that were not performed;
- security or privacy impact; and
- any AI assistance that materially influenced code, tests, or technical claims.

Compatibility claims require repeatable evidence for the named controller, Mac architecture, macOS version, connection method, and consuming software. Enumeration, a single successful session, or an AI-generated conclusion is not compatibility evidence.

## Security and privacy

The project follows least privilege, collects only the diagnostic data needed for a test, and treats device descriptors and input reports as untrusted data. Unique device identifiers, credentials, signing material, local paths, and unrelated system data must not enter issues, fixtures, logs, prompts, or commits.

Security-sensitive reports follow [SECURITY.md](SECURITY.md). Changes involving dependencies, entitlements, device access, privileged components, signing, or distribution require an issue and an explicit security review before implementation.

## AI-assisted development

AI tools may assist with research, drafting, implementation, testing, and review. They do not hold decision authority and do not bypass branch protections, tests, evidence requirements, or human review. The owner remains responsible for every accepted change and public claim.

See [AI-assisted development](docs/AI_DEVELOPMENT.md) for the working controls.

## Releases and policy changes

A release must be tagged from protected `main` only after its stated checks pass. Release notes must distinguish verified behavior from experimental, partial, failed, and untested behavior.

Material governance changes are made through a pull request so the rationale and history remain public.
