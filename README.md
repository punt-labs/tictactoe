# TicTacToe

A Pharo 12 Smalltalk TicTacToe implementation with minimax AI. Exported from
an agent evaluation session that originally targeted the
[`claude-agent-sdk-smalltalk`](https://github.com/punt-labs/claude-agent-sdk-smalltalk)
agent runtime as the "simplest thing that could possibly work" to demonstrate
the agent driving real Smalltalk code.

## Origin

This package was written in Pharo by a Claude agent session on 2026-04-08
using the `Refactor`, `CompileMethod`, `DefineClass`, and `RunTests` tools
from `claude-agent-sdk-smalltalk`. The session completed the full game
including:

- `TTTGame` — the game state and move engine
- `TTTBoardMorph` — the Morphic UI (click a cell to play)
- `TTTCellMorph` — individual cell rendering
- `TTTMinimax` — perfect-play AI using the minimax algorithm
- `TTTGameTest` — game logic tests
- `TTTMinimaxTest` — AI tests

The agent evaluation was proof that two-step prompting (spec first, then
implement) transforms complex task success at Level 5 — see the
claude-agent-sdk-smalltalk README eval section for the full methodology.

## Loading

This is a Tonel-format Pharo package. From a running Pharo image:

```smalltalk
"Via Iceberg"
IceRepositoryCreator new
    location: '/path/to/tictactoe' asFileReference;
    subdirectory: 'TicTacToe';
    createRepository.

"Or via Metacello"
Metacello new
    baseline: 'TicTacToe';
    repository: 'github://punt-labs/tictactoe';
    load.
```

## Running

```smalltalk
TTTBoardMorph new openInWindow.
```

Click a cell to play as X. The minimax AI plays O and makes perfect moves.

## Tests

```smalltalk
TTTGameTest buildSuite run.
TTTMinimaxTest buildSuite run.
```

## License

Part of the Punt Labs ecosystem. Licensed alongside claude-agent-sdk-smalltalk.
