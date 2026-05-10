Extension { #name : #GtLModelFactory }

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
