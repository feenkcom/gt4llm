# gt4llm

is a library for working with LLMs, designed for use with Glamorous Toolkit.

Currently it includes:
- A client for [OpenAI](https://openai.com),
- Some general utilities for working with LLMs.
## Installation```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4Llm';	load```

If you want the OpenAI-specific code, you can additionally install:

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4OpenAI';	load```

If you want the Ollama-specific code, you can additionally install:

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4Ollama';	load```## Load Lepiter				After installing the OpenAI client with Metacello, you will be able to execute```#BaselineOfGt4OpenAI asClass loadLepiter```

After installing the Ollama client with Metacello, you will be able to execute```#BaselineOfGt4Ollama asClass loadLepiter```
<hr/>

Have fun!