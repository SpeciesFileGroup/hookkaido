## [Unreleased]

## [0.1.1] - 2026-06-17
 - Allow Ruby 4.0.0:
    - Relaxed `required_ruby_version` to `>= 2.5.0, < 5.0`
    - Added Ruby 4.0.0 to the CI matrix
    - Bumped `faraday-follow_redirects` upper bound to allow 0.5+ (which lifts the Ruby < 4 cap)
 - Added test suite (test-unit + VCR + webmock) covering version, ontologies, and search
 - Added GitHub Actions workflow

## [0.1.0]
 - Initial release
