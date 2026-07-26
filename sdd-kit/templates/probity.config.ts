import { defineConfig, enforceTdd, forbidCommandPattern } from '@nizos/probity'

/**
 * SDD Probity config — template for APP/HYBRID repos (G2).
 * Copied to repo root by: bash sdd-kit/install-probity-module.sh --apply
 * Pin: @nizos/probity@1.10.0
 */
export default defineConfig({
  rules: [
    {
      files: [
        'app/**',
        'components/**',
        'lib/**',
        'src/**',
        '**/*.{test,spec}.{ts,tsx,js,jsx}',
        'tests/**',
        'test/**',
        '__tests__/**',
        '!doc/**',
        '!openspec/**',
        '!sdd-kit/**',
      ],
      rules: [
        enforceTdd({
          instructions: (defaults) => `${defaults}

### SDD R6 addendum
- Bug fix (tipo B): MUST demonstrate a failing test reproducing the bug before changing production code.
- Refactor (tipo C): existing tests MUST stay green; new behaviour requires new failing tests first.
- Feature (tipo D): red-green-refactor cycle per acceptance criterion.`,
        }),
      ],
    },
    forbidCommandPattern({
      match: /rm\s+-rf/,
      reason: 'Destructive rm blocked per SDD security rule 050-security.',
    }),
  ],
})
