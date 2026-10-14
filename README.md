# Sumer Labs — Application Infrastructure

**Terraform | Microsoft Azure | Platform-Owned Terraform CI | Policy as Code**

Application-specific Azure infrastructure managed with Terraform and validated through centrally maintained platform standards and CI workflows.

---

## Table of Contents

- [Overview](#overview)
- [Objectives](#objectives)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Application Infrastructure](#application-infrastructure)
- [Central Platform Integration](#central-platform-integration)
- [Terraform CI Workflow](#terraform-ci-workflow)
- [Policy as Code](#policy-as-code)
- [Azure Authentication](#azure-authentication)
- [Development Workflow](#development-workflow)
- [Security Guidelines](#security-guidelines)
- [Responsibilities and Ownership](#responsibilities-and-ownership)
- [Scope and Limitations](#scope-and-limitations)
- [Related Repository](#related-repository)

## Overview

This repository contains application-specific Terraform configuration for infrastructure on Microsoft Azure.

It follows a platform-owned Infrastructure as Code (IaC) model in which application teams manage their infrastructure requirements while consuming centrally maintained Terraform modules, configuration standards, and CI capabilities.

The central platform repository provides shared infrastructure components and governance controls. This application repository focuses on defining the infrastructure required by the application and integrating with the platform's Terraform CI workflow.

### Objectives

- Define application-specific Azure infrastructure using Terraform.
- Consume reusable infrastructure modules maintained by the platform team.
- Follow centrally managed Terraform and AzureRM provider standards.
- Validate infrastructure changes through automated CI checks.
- Evaluate applicable infrastructure policies before changes are approved.
- Use secure Azure authentication and appropriate access controls.
- Keep infrastructure changes reviewable through pull requests and Terraform plans.

## Architecture

The application repository consumes infrastructure and CI capabilities maintained in the central platform repository.

```text
Application Repository
        |
        | Terraform Configuration
        |
        v
Central Terraform Modules
        |
        v
Platform-Owned Terraform CI
        |
        +--> Terraform Setup and Validation
        |
        +--> Terraform Tests
        |
        +--> Security Checks, Where Configured
        |
        +--> Terraform Plan
        |
        +--> OPA Policy Evaluation
        |
        v
Configured Pull Request Checks
```

The exact execution sequence and enforcement behavior depend on the reusable workflow implemented in the platform repository.

## Repository Structure

The repository contains application-specific infrastructure configuration and integrates with shared platform capabilities.

The directory structure below is illustrative and should be adjusted to match the actual files in this repository.

```text
Sumer_Labs_Application1/
├── Infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── environments/
│       └── dev.tfvars
└── README.md
```

### Directory Responsibilities

| Path | Responsibility |
|---|---|
| `Infra/` | Application-specific Terraform configuration |
| `Infra/main.tf` | Application infrastructure definitions and module references |
| `Infra/variables.tf` | Configurable infrastructure inputs |
| `Infra/outputs.tf` | Values exposed by the Terraform configuration |
| `Infra/environments/` | Environment-specific input files, where used |

This is a target example, not a declaration that every listed file currently exists. The actual repository structure and Terraform configuration are the source of truth.

## Application Infrastructure

The application team is responsible for defining the infrastructure required by the application.

This can include:

- Selecting approved infrastructure modules.
- Supplying application-specific configuration.
- Defining supported environment inputs.
- Connecting module outputs to dependent resources.
- Reviewing proposed infrastructure changes.
- Maintaining compatibility with platform module interfaces.

Shared infrastructure implementations should be consumed from the central platform repository rather than duplicated in each application repository.

## Central Platform Integration

The application repository integrates with:

**[Azure_Central_Terraform_Modules](https://github.com/Sumer-Labs/Azure_Central_Terraform_Modules)**

The platform repository centrally maintains shared infrastructure capabilities and standards.

### Platform-Owned Capabilities

- Reusable Azure Terraform modules.
- Common Terraform and AzureRM provider configuration standards.
- Backend configuration conventions.
- Shared Policy as Code definitions.
- Reusable GitHub Actions workflows.
- Platform release metadata.

### Application-Owned Capabilities

- Application-specific Terraform configuration.
- Application infrastructure requirements.
- Environment-specific inputs.
- Module consumption and integration.
- Pull request changes and infrastructure review.

This separation keeps shared infrastructure and governance controls under platform ownership while allowing application teams to manage their own infrastructure requirements.

## Terraform CI Workflow

Infrastructure changes are intended to be validated through the platform-owned Terraform CI workflow.

The configured workflow may include the following stages.

### 1. Terraform Setup and Initialization

Select the approved Terraform version and initialize the configuration with the required providers and modules.

### 2. Formatting and Validation

Check Terraform formatting and validate the configuration to identify errors before infrastructure changes are approved.

### 3. Terraform Tests

Run the applicable automated tests to verify infrastructure module behavior and configuration expectations.

### 4. Security Checks

Run the security scanning tools configured by the platform workflow to identify applicable infrastructure misconfigurations.

### 5. Terraform Plan

Generate a Terraform plan to describe proposed infrastructure changes.

Reviewing the plan helps identify unexpected resource creation, modification, or deletion.

### 6. Policy Evaluation

Evaluate applicable policy inputs against the centrally maintained Rego policies in the platform repository.

The workflow must supply the correct input and handle policy results according to the configured enforcement rules.

### 7. Pull Request Checks

Report the configured CI results to the pull request. Required checks can be enforced through repository rules or branch protection settings.

The actual workflow implementation determines which stages run and which failures block a pull request.

## Policy as Code

The platform repository maintains shared infrastructure governance policies, including the required-tags policy:

`Policy As code/terraform/common/required_tags.rego`

Application infrastructure changes can be evaluated against the applicable platform policies through the configured CI workflow.

Policy evaluation is intended to help establish consistent infrastructure requirements across application repositories.

Examples of possible policy requirements include mandatory resource tags and approved configuration attributes, depending on the rules implemented by the platform team.

The presence of a central policy does not automatically enforce it. The workflow must explicitly invoke OPA, supply compatible input, and handle policy failures correctly.

## Azure Authentication

Azure authentication is intended to follow the centrally managed platform approach.

GitHub Actions OpenID Connect (OIDC) can establish a federated identity between GitHub and Microsoft Entra ID, avoiding the need for a long-lived client secret in the workflow where correctly configured.

The integration requires:

- An appropriate federated identity configuration.
- Matching GitHub repository, branch, or environment claims.
- Required GitHub Actions permissions.
- Appropriate Azure role assignments.
- Access to the resources required by the workflow.

Azure permissions should follow the principle of least privilege. Terraform state access and infrastructure management permissions should be scoped appropriately.

## Development Workflow

The intended infrastructure development lifecycle is:

1. Update the application Terraform configuration.
2. Review the modified resources, module references, and environment inputs.
3. Create a pull request.
4. Allow the configured platform Terraform CI workflow to execute.
5. Review Terraform validation and test results.
6. Review security findings and policy evaluation results.
7. Inspect the Terraform plan.
8. Address failed checks and unexpected infrastructure changes.
9. Request review and approval according to repository rules.

A successful CI run indicates that the configured checks passed; it does not indicate that infrastructure has been deployed.

## Security Guidelines

- Never commit credentials, client secrets, or sensitive variable values.
- Never commit Terraform state files.
- Use approved Terraform modules and platform configuration.
- Follow the configured Azure authentication and access-control model.
- Keep permissions scoped to the required resources.
- Review Terraform plans before approving infrastructure changes.
- Resolve security and policy findings according to platform requirements.
- Do not bypass required CI checks without an approved exception.

## Responsibilities and Ownership

| Responsibility | Platform team | Application team |
|---|---|---|
| Shared Terraform modules | Maintains implementation and interfaces | Consumes approved modules |
| Terraform and provider standards | Defines common standards | Uses supported configuration |
| Policy as Code | Maintains common policy definitions | Supplies supported inputs and resolves findings |
| CI workflow | Maintains reusable workflow | Invokes configured workflow |
| Application infrastructure | Provides reusable building blocks | Defines application-specific resources |
| Environment inputs | Defines conventions | Maintains application inputs |
| Azure access | Defines access patterns | Uses approved identity and permissions |
| Infrastructure review | Defines common CI expectations | Reviews proposed changes |

## Scope and Limitations

This repository focuses on application-specific infrastructure configuration and integration with platform-owned Terraform CI.

The CI process is intended to cover validation, testing, applicable security checks, Terraform planning, and policy evaluation.

Automated production deployment and Terraform apply operations are outside the scope described here.

A successful CI run does not mean that infrastructure has been deployed or that `terraform apply` has been executed.

The actual repository files and configured workflows determine which capabilities are currently implemented and enforced.

## Related Repository

**Central platform repository:**

[Azure_Central_Terraform_Modules](https://github.com/Sumer-Labs/Azure_Central_Terraform_Modules)

This repository provides the shared Terraform modules, platform configuration standards, policy definitions, and reusable CI capabilities consumed by application repositories.

## Contribution Guidelines

Before proposing infrastructure changes:

1. Review the existing Terraform configuration and module interfaces.
2. Use approved platform modules and standards.
3. Update relevant documentation when configuration changes.
4. Run applicable validation and tests.
5. Review security and policy results.
6. Inspect the Terraform plan.
7. Document compatibility concerns or breaking changes.

## Status

This README describes the intended application infrastructure and platform integration model.

The actual Terraform files, reusable workflow definitions, and configured repository rules determine the functionality currently available.
