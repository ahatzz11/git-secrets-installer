### [`git-secrets`](https://github.com/awslabs/git-secrets)

`git-secrets` is a set of git hooks that protects you against committing passwords into git. Instead of the commit being made you will be warned that are you attempting to commit something that is considered a secret.

This increases team security and decreases mistakes that can often lead to rotating passwords, which is a huge pain.

### Installing

1. Run the oneliner

	```
	git clone https://github.com/ahatzz11/git-secrets-installer.git; cd git-secrets-installer; chmod +x install-git-secrets.sh; ./install-git-secrets.sh
	```

	It will:
	* Install `git-secrets` on your machine
	* Install hooks on all existing local git repositories
	* Turn on automatic hook installation on future clones
	* Create a default ruleset to match the following patterns:
	  ```
	  (.*)password:
	  (.*)password=
	  (.*)secret:
	  (.*)secret=
	  ```
	  Having the property name is fine, but if you have any characters (including white spaces) it won't let you commit.

2. Restart your terminal and verify this worked by running:

	```
	git secrets --list --global
	```

### Useful commands

Add a pattern to the ruleset:

```
git secrets --add --global $textToMatch
```

Add a pattern to the allowed list:

```
git secrets --add --allowed --global $allowedTextOrPattern
```
