# Automatic publication of Python packages to PyPI

This repository defines a Github action to provide opt-in automatic publication of python packages to PyPI upon qualifying Github release events.
This repository also serves as the documentation for the service. This repository does not need to be cloned or interacted with in order to take advantage of the service.

Default criteria for publishing a release:
   * Tag must conform to the semantic versioning specification (https://semver.org/)

## How to use

The publication mechanism is provided on an opt-in basis to repositories within the following Github organizations:
   * spacetelescope

Stipulations:
   * If the project being published already exists on PyPI, the PyPI account named `stsci_maintainer` must be defined as a 'maintainer'.
      * If you wish to specify the set of credentials used to publish the package, please see 'Using other credentials' below.
   * If the project does not yet exist, it will be created on PyPI by the account `stsci_maintainer`.

### To add publication capability to a repository

   1) On the main repository page, click **Actions** at the top, just below the name of the repository.
   2) In the **Workflows made for your Python repository**, locate the "*Publish to PyPI*" workflow made by "Space Telescope Science Institute"
   3) Click the **Set up this workflow** button. This will open a commit page with the workflow code that will be added to the repository.
   4) Click the **Start Commit** button in the upper right hand corner.
   5) Add a descriptive commit message if you like. "Activating automatic PyPI publication" or similar.
   6) Click **Commit new file**.
   
Whenever a new release with a semver-compliant tag is made on Github from the repository, the package will be created and published to PyPI using the `stsci_maintainer` account.

### Using other credentials

The default set of credentials used to publish packages to PyPI are those of the PyPI account `stsci_maintainer`. If you want or need to use other credentials, they may be specified as secrets in the settings of the Github repository.

   1) Open the **Settings** page of the repository (top porton of the page, on the line under the repository name)
   2) Select **Secrets** from the list on the left hand side.
   3) Define a secret with the name `PYPI_USERNAME_OVERRIDE` the value of which is the PyPI username to be used.
   4) Define another secret with the name `PYPI_PASSWORD_OVERRIDE` the value of which is the PyPI password to be used.
   
Whenever a new release is made, the package will be created and published to PyPI using the supplied credentials.

## Problems

If a problem occurs with the publication, an e-mail message with "Run failed: Publish to PyPI" in the subject will be sent to you containing a link to the logs from the attempt.
