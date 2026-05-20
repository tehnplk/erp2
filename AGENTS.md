## RULE
### Don't do if user not ask
-test 
-build
-deploy

## Tech Stack
- use 'npx ctx7' cli to research new knowledge

## Database manage ment
- use `db-cli --skill` to access and manage database
- read @.env* to  to get db credatial

## Testing
- Run dev server only on port 3000  (you can kill running port by `npx kill-port 3000` before re-run)
- use browser (playwright-cli) to test
- always run `playwright-cli show` to show user what are you doing.
- if user ask for annotate use `playwright-cli --annotate` and wait user annotation input
