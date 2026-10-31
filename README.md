# CodeLaser's Homebrew tap

[maddi](https://github.com/CodeLaser/maddi), the modification and immutability analyzer for Java, for macOS and
Linux. Each formula installs the distribution from maddi's
[GitHub release](https://github.com/CodeLaser/maddi/releases) together with the JDK it runs on.

```bash
brew install codelaser/tap/maddi          # the command line, for Java projects
brew install codelaser/tap/maddi-kotlin   # the command line, for projects with Kotlin sources too
brew install codelaser/tap/maddi-mcp      # the MCP server for coding agents (from 0.9.6)
```

Homebrew 7 marks a tap like this one untrusted. Installing a formula by its full name, as above, works all the
same; `brew info` and `brew audit` on it ask you to trust the tap first: `brew trust codelaser/tap`.

Register the MCP server with your agent, for Claude Code:

```bash
claude mcp add maddi -- $(brew --prefix)/bin/maddi-mcp
```

| Formula | Runs on | What it is |
|---|---|---|
| `maddi` | `openjdk@25` | `maddi`, the command line: analysis, annotated APIs, translation to Kotlin, C# and Rust |
| `maddi-kotlin` | `openjdk` (26 or later) | `maddi-kotlin`: the same options, for projects with Kotlin sources |
| `maddi-mcp` | `openjdk@25` | `maddi-mcp`, the [MCP server](https://github.com/CodeLaser/maddi-dist#coding-agents-mcp), with the analysis daemon it starts |

Each formula installs the JDK it needs, and runs on it. To run on another JDK, Temurin for example, name it in
`MADDI_JDK_HOME`; it must be 25 or later (26 for `maddi-kotlin`), which is checked:

```bash
export MADDI_JDK_HOME=/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home   # Temurin 25 on macOS
```

For `maddi-mcp`, the variable chooses the JDK of the server and of the analysis daemon it starts.

The formulas are updated by maddi's release script (`release-cli.sh` in
[maddi-dist](https://github.com/CodeLaser/maddi-dist)) at every release. Issues with maddi itself go to
[CodeLaser/maddi](https://github.com/CodeLaser/maddi/issues).

Licensed under the [Apache License, Version 2.0](LICENSE).
