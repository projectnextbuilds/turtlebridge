# AI-assisted development

TurtleBridge uses AI as a development aid under human control. This document makes that use reviewable without treating AI-generated output as proof.

## Permitted assistance

AI tools may help:

- explore implementation options and platform documentation;
- draft focused code, tests, documentation, and issue text;
- identify edge cases and review changes; and
- summarize build or test output.

## Required controls

AI output is treated as an untrusted draft. Before it is accepted, the repository owner must:

1. understand the change and keep it within an approved issue or documented scope;
2. inspect the diff for correctness, security, privacy, and maintainability;
3. run the checks appropriate to the change and record what was not tested;
4. verify platform facts against authoritative sources or direct observation; and
5. use a protected pull-request path to merge the change.

No AI tool can approve its own work, establish hardware compatibility, or substitute for a real-device test.

## Data handling

Do not provide an AI service with secrets, credentials, signing material, private vulnerability details, controller serial numbers, account names, hostnames, local paths, or raw system/device dumps containing unrelated data.

Use the minimum sanitized excerpt needed to solve the problem. Treat generated fixtures and logs as potentially sensitive until they have been reviewed. Follow [SECURITY.md](../SECURITY.md) for vulnerability reports.

## Disclosure and traceability

Pull requests disclose material AI assistance and identify the areas it influenced. Routine editor completion does not need a transcript. Prompts and private reasoning are not published by default; the durable record is the issue, focused diff, test evidence, limitations, review, and commit history.

AI-assisted changes are held to the same—and for security-sensitive work, a higher—verification standard as manually authored changes.
