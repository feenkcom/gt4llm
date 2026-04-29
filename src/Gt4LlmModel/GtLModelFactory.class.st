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
GtLModelFactory >> ollama_gemma4 [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaCompletionsGemma4Endpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	^ model.
]

{ #category : #'specific models' }
GtLModelFactory >> ollama_gemma4_31b [
	| model |

	model := self ollama_gemma4.
	model name: 'gemma4:31b'.
	^ model.
]

{ #category : #'specific models' }
GtLModelFactory >> ollama_gemma4_31b_native [
	| model |

	model := self ollama_gemma4_native.
	model name: 'gemma4:31b'.
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_gemma4_native [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaGenerateEndpoint new
			reasoningValidator: self defaultOllamaGenerateReasoningValidator.
	model endpointAt: 'userMessage' put: chatEndpoint.
	^ model.
]

{ #category : #'specific models' }
GtLModelFactory >> ollama_llama3_2 [
	| model |

	model := self ollama.
	model 
		name: 'llama3.2';
		endpointAt: 'userMessage' put: (GtLOllamaGenerateEndpoint new
			reasoningValidator: self defaultOllamaGenerateReasoningValidator).
	^ model.
]

{ #category : #'base models' }
GtLModelFactory >> ollama_qwen3_6 [
	| model chatEndpoint |

	model := self ollama.
	chatEndpoint := GtLOllamaCompletionsGemma4Endpoint new
		reasoningValidator: self defaultOllamaCompletionsReasoningValidator.
	model 
		name: 'qwen3.6';
		endpointAt: 'userMessage' put: chatEndpoint.

	^ model.
]
