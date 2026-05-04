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
	| model provider chat client |

	provider := GtLModelProvider new.
	client := GtLModelClient new.
	model := GtLLlmModel new
		provider: provider;
		client: client.
	model
		endpointAt: 'providerVersion' put: GtLOllamaVersionEndpoint new;
		endpointAt: 'modelDetails' put: GtLOllamaModelDetailsEndpoint new;
		endpointAt: 'availableModels' put: GtLOllamaAvailableModelsEndpoint new;
		endpointAt: 'runningModels' put: GtLOllamaPsEndpoint new.
	chat := GtLModelChat new
		model: model.
	provider chat: chat.
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_completions [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaCompletionsEndpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
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
