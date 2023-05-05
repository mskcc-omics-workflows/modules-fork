---
description: Description of standards and how to use the MSK's nf-core/module fork
---

# Repo Overview

Repository: [mskcc-omics-workflows/modules](https://github.com/mskcc-omics-workflows/modules) &#x20;

## Adding a Module

1. First make a branch from master with the following naming convention: `feature/module_name`
2. On the new feature branch run the following: `nf-core module create <module_name>`
3. Write your module. Please consult the [nf-core official documentation](https://nf-co.re/developers/tutorials/dsl2\_modules\_tutorial) for how to do this.
   * Note you can ignore the **Fork the nf-core/modules repository and branch,** **Pull Request and Test Data** sections in the nf-core documentation. We are covering how to make a Pull Request into MSK's fork of nf-core and add test data in this section.
   * It may also be useful to reference the [nextflow official documentation](https://www.nextflow.io/docs/latest/index.html) as well.&#x20;
4.  Add test data to the [tools-test-data](https://github.mskcc.org/MSKCC-Omics-Workflows/tools-test-dataset) enterprise repository. Tools-test-data is a submodule in mskcc-omics-workflows/modules and can be accessed with the following:

    ```
    git submodule update --init --recursive 
    ```
5. Merge into the develop branch. Develop branch is review protected. It will require reviews from a representative on each team.&#x20;
6. Develop is released to master on a 2 week schedule.&#x20;

## What to do if there is a need to edit an nf-core module?&#x20;

1. Try to merge to nf-core/module with change
2. If there is need to edit an nf-core specific module, it is important to not edit the nf-core as this will interfer with the automatic fork syncing. Instead follow the steps in the Adding a Module section. The only difference is you will need to run: `nf-core module create nfmsk/<module_name>.`This creates a new version of the edited nf-core module that won't interfer with the fork syncing and organizes them in one place to reference.&#x20;

## Creating a Pipeline

* nf-core create pipeline name
* template editor tool

## Installing Module/Subworkflows

### installing modules:

`nf-core modules --git-remote https://github.com/mskcc-omics-workflows/mskcc-modules.git --branch <branch> install <module_name>`

### installing subworkflows:&#x20;

`nf-core subworkflows --git-remote https://github.com/mskcc-omics-workflows/mskcc-modules.git --branch <branch> install <subworkflow_name>`

This should install all modules associated with the subworklows.

**\*Note you will have to authenticate**

Use the following command to not be prompted for credentials:&#x20;

`nf-core subworkflows --git-remote https://<username:password>@github.com/mskcc-omics-workflows/mskcc-modules.git --branch <branch> install <subworkflow_name>`\


