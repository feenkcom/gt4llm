# gt4llm

is a library for working with LLMs, designed for use with Glamorous Toolkit.

Currently it includes:
- A client for [OpenAI](https://openai.com),
- A client for [Ollama](https://ollama.com)
- General utilities for working with LLMs.
- Examples of integrating LLMs in user interfaces

## Installation

There are two ways to install the `gt4llm` package in a [Glamorous Toolkit image](https://gtoolkit.com): either through a complete installation, or through installing the core and specific adapters only.

### Complete installation

```st
Metacello new
	repository: 'github://feenkcom/gt4llm:main/src';
	baseline: 'Gt4Llm';
	load.
#BaselineOfGt4Llm asClass loadAllLepiterDatabases
```
### Custom installation

```st
Metacello new
	repository: 'github://feenkcom/gt4llm:main/src';
	baseline: 'Gt4LlmCore';
	load
```

If you want the OpenAI-specific code, you can additionally install:

```st
Metacello new
	repository: 'github://feenkcom/gt4llm:main/src';
	baseline: 'Gt4OpenAI';
	load
```
```st
#BaselineOfGt4OpenAI asClass loadLepiter
```

If you want the Ollama-specific code, you can additionally install:

```st
Metacello new
	repository: 'github://feenkcom/gt4llm:main/src';
	baseline: 'Gt4Ollama';
	load
```
```st
#BaselineOfGt4Ollama asClass loadLepiter
```

<hr/>

Have fun!
