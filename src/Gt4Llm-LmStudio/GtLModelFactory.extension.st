Extension { #name : #GtLModelFactory }

{ #category : #'*Gt4Llm-LmStudio' }
GtLModelFactory >> lmstudio [
	"LM Studio provides Open AI /v1/completions compatibility that is similar enough to Ollama that we are just using the Ollama configuration for now."
	| model provider client chat |

	provider := GtLLmStudioProvider new.
	client := GtLOllamaClient new.
	model := GtLLlmModel new
		provider: provider;
		client: client.
	model client baseUrl: 'http://localhost:1234' asZnUrl.
	model
		endpointAt: 'availableModels' put: GtLOpenAiV1AvailableModelsEndpoint new.
	chat := GtLChat new
		provider: provider.
	^ model
]

{ #category : #'*Gt4Llm-LmStudio' }
GtLModelFactory >> lmstudio_completions [
	| model chatEndpoint |

	model := self lmstudio.
	chatEndpoint := GtLOllamaCompletionsEndpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	^ model.
]

{ #category : #'*Gt4Llm-LmStudio' }
GtLModelFactory >> lmstudio_completions: modelName [

	^ self lmstudio_completions
		name: modelName.
]
