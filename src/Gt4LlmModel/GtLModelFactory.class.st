Class {
	#name : #GtLModelFactory,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Model'
}

{ #category : #accessing }
GtLModelFactory >> defaultOllamaCompletionsReasoningValidator [

	^ GtLModelReasoningValidator new
		noneValues: #(#none);
		reasoningValues: #(#low #medium #high).
]

{ #category : #accessing }
GtLModelFactory >> defaultOllamaGenerateReasoningValidator [

	^ GtLModelReasoningValidator new
		noneValues: #(false #none);
		reasoningValues: #(true #low #medium #high).
]

{ #category : #providers }
GtLModelFactory >> ollama [
	"Answer a partially configured Ollama model.
	Details of the LLM model to be added by the caller."
	| model provider client |

	provider := GtLOllamaProvider new.
	client := GtLOllamaClient new.
	model := GtLLlmModel new
		provider: provider;
		client: client.
	model
		endpointAt: 'providerVersion' put: GtLOllamaVersionEndpoint new;
		endpointAt: 'modelDetails' put: GtLOllamaModelDetailsEndpoint new;
		endpointAt: 'availableModels' put: GtLOllamaAvailableModelsEndpoint new;
		endpointAt: 'runningModels' put: GtLOllamaPsEndpoint new;
		endpointAt: 'deleteModel' put: GtLOllamaDeleteEndpoint new;
		endpointAt: 'pullModel' put: GtLOllamaPullEndpoint new;
		endpointAt: 'createEmbeddings' put: GtLOllamaCreateEmbeddingsEndpoint new;
		endpointAt: 'createModel' put: GtLOllamaCreateModelEndpoint new.
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_completions [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaCompletionsEndpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	
	"model
		optionAt: 'dataSourceRequestParser' put: GtLDataSourceOpenAiCompletionsRequestParser new;
		optionAt: 'dataSourceResponseParser' put: GtLDataSourceOpenAiCompletionsResponseParser new."
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_completions: modelName [

	^ self ollama_completions
		name: modelName.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_generate [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaGenerateEndpoint new
			reasoningValidator: self defaultOllamaGenerateReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_generate: modelName [

	^ self ollama_generate
		name: modelName
]

{ #category : #'specific models' }
GtLModelFactory >> ollama_llama3_2 [

	^ self ollama_generate: 'llama3.2'
]

{ #category : #providers }
GtLModelFactory >> openAi [
	"Answer a partially configured Open AI model.
	Details of the LLM model to be added by the caller.
	This is a WIP being developed against the Ollama implementation for now."
	| model provider chat client |

	provider := GtLOpenAiResponsesProvider new.
	client := GtLOllamaClient new.
	model := GtLLlmModel new
		provider: provider;
		client: client.
	model
		endpointAt: 'providerVersion' put: GtLOllamaVersionEndpoint new;
		endpointAt: 'modelDetails' put: GtLOllamaModelDetailsEndpoint new;
		endpointAt: 'availableModels' put: GtLOllamaAvailableModelsEndpoint new;
		endpointAt: 'runningModels' put: GtLOllamaPsEndpoint new;
		endpointAt: 'createEmbeddings' put: GtLOllamaCreateEmbeddingsEndpoint new.
	chat := GtLChat new
		provider: provider.
	^ model.
]

{ #category : #'as yet unclassified' }
GtLModelFactory >> openAi_responses [
	"Answer a partially configured OpenAI model.
	This is a WIP"
	| model |

	model := self openAi.
	
	model
		optionAt: 'dataSourceRequestParser' put: GtLDataSourceOpenAiResponsesRequestParser new;
		optionAt: 'dataSourceResponseParser' put: GtLDataSourceOpenAiResponsesResponseParser new.
		
	^ model
]
