# gt4llm

is a library for working with LLMs, designed for use with [Glamorous Toolkit](https://gtoolkit.com).

Currently it includes:
- A client for [OpenAI](https://openai.com)
- A client for [Ollama](https://ollama.com)
- General utilities for working with LLMs
- Examples of integrating LLMs in user interfaces

## Installation

To install the `gt4llm` package in a [Glamorous Toolkit image](https://gtoolkit.com) simply execute the following Pharo snippet in the environment:

```st
Metacello new
	repository: 'github://feenkcom/gt4llm:main/src';
	baseline: 'Gt4Llm';
	load.
#BaselineOfGt4Llm asClass loadLepiter
```

Have fun!
