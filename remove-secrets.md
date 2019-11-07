### Scanning and Removing

This process helps you find and clean up any passwords that have previously been comitted to Git. Make sure you're at the root folder where `.git` is accessible before running these commands.

1. To see any secrets from the entire history of a git repo:
	```
	git secrets --scan-history
	```

	The results will be shown to you, similar to this:
	```
	git secrets --scan-history
	ff3fca43f54f6b0287d47e95948f61c20f76bf8c:src/main/resources/application.yml:5:    password: 1234567890
	ff3fca43f54f6b0287d47e95948f61c20f76bf8c:src/main/resources/application.yml:31:    password: 1234567890
	5de1665f3325216fd49c6bb6bdeef5e642755797:src/main/resources/application.yml:5:    password: 1234567890
	5de1665f3325216fd49c6bb6bdeef5e642755797:src/main/resources/application.yml:31:    password: 0987654321
	213bedfbf1b43147b779c94dabc653a2e8cd3a9f:src/main/resources/application.yml:5:    password: 0987654321
	```

2. Install [bfg repo cleaner](https://rtyley.github.io/bfg-repo-cleaner/).

	This is a tool that [GitHub reccommends](https://help.github.com/articles/removing-sensitive-data-from-a-repository/).

	```
	brew install bfg
	```

3. Take the secrets that are seen in step 1 from `git secrets` and put them into a new file.

	```
	touch delete-this-password-file.txt
	```

	This file will look something like this:

	```
	1234567890
	0987654321
	```

4. Run the following bfg command to remove all instances of the passwords in the `delete-this-password-file.txt` file from your git history:

	```
	bfg --replace-text delete-this-password-file.txt
	```

	This will rewrite your local git history and censor out all of your passwords.

	If you were to scan again, you would get:

	```
	git secrets --scan-history
	ff3fca43f54f6b0287d47e95948f61c20f76bf8c:src/main/resources/application.yml:5:    password: ***REMOVED***
	ff3fca43f54f6b0287d47e95948f61c20f76bf8c:src/main/resources/application.yml:31:    password: ***REMOVED***
	5de1665f3325216fd49c6bb6bdeef5e642755797:src/main/resources/application.yml:5:    password: ***REMOVED***
	5de1665f3325216fd49c6bb6bdeef5e642755797:src/main/resources/application.yml:31:    password: ***REMOVED***
	213bedfbf1b43147b779c94dabc653a2e8cd3a9f:src/main/resources/application.yml:5:    password: ***REMOVED***
	```

5. Finalize the bfg cleanup
	```
	git reflog expire --expire=now --all && git gc --prune=now --aggressive
	```

	This command will strip out the unwanted dirty data.

6. Push to git. Make sure to push to all branches and tags so all the dirty commits are removed.

	```
	git push -f --all
	git push -f --tags
	```
