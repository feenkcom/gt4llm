# gt4llm

is a library for working with LLMs, designed for use with Glamorous Toolkit.

Currently it includes:
- A client for [OpenAI](https://openai.com),
- Some general utilities for working with LLMs.
## InstallationThere are two ways to install the `gt4llm` package: either through a complete installation, or through installing the core and specific adapters only.

### Complete installation

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4Llm';	load```

#### Load Lepiter
```st#BaselineOfGt4Llm asClass loadAllLepiterDatabases```
### Custom installation

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4LlmCore';	load```

If you want the OpenAI-specific code, you can additionally install:

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4OpenAI';	load```

If you want the Ollama-specific code, you can additionally install:

```stMetacello new	repository: 'github://feenkcom/gt4llm:main/src';	baseline: 'Gt4Ollama';	load```#### Load Lepiter				After installing the OpenAI client with Metacello, you will be able to execute```st#BaselineOfGt4OpenAI asClass loadLepiter```

After installing the Ollama client with Metacello, you will be able to execute```st#BaselineOfGt4Ollama asClass loadLepiter```
<hr/>

Have fun!