Class {
	#name : #GtLOpenAiResponsesProvider,
	#superclass : #GtLModelProvider,
	#category : #'Gt4LlmModel-Provider'
}

{ #category : #testing }
GtLOpenAiResponsesProvider class >> isConnectable [
	| model provider |

	model := GtLModelFactory new ollama.
	provider := model provider.
	^ [ provider availableModels isNotEmpty ]
		on: Error
		do: [ :ex | false ].
]

{ #category : #accessing }
GtLOpenAiResponsesProvider class >> providerName [
	^ 'Ollama'
]

{ #category : #accessing }
GtLOpenAiResponsesProvider >> defaultUserMessageClass [

	^ GtLModelUserMessage
]

{ #category : #accessing }
GtLOpenAiResponsesProvider >> modelName: aString [
	| newModel |

	newModel := GtLModelFactory new ollama_completions: aString.
	newModel provider: self.
	chat := GtLChat new
		provider: self.
]
