# I am a test

## How to use me

1. Add workflows here for things you want, exactly duplicate of what will live in the prod environment (e.g docker push)
2. Track the `dev` branch of the [/actions](https://github.com/phylaxsystems/actions) repository
3. Push changes to `dev`
4. Go to the actions in this repository and `re-run` an action. It will pull the latest commit from the `dev` branch and run the workflow. This works even if the action was ran succesfully. This enables you to just push changes to `dev` without needing to also push a change in this repo to trigger the workflow run.
5. After you are done, open a PR and (SQUASH) merge it into the default branch of `/actions`.
6. Make sure to reset `\dev` to the default branch, so that it's ready to be worked on for any new change
7. Rinse and repeat
