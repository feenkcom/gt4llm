Class {
	#name : #GtLOllamaProvider,
	#superclass : #GtLModelProvider,
	#category : #'Gt4Llm-Ollama-Provider'
}

{ #category : #testing }
GtLOllamaProvider class >> isConnectable [
	| model provider |

	model := GtLModelFactory new ollama.
	provider := model provider.
	^ [ provider availableModels isNotEmpty ]
		on: Error
		do: [ :ex | false ].
]

{ #category : #accessing }
GtLOllamaProvider class >> providerName [
	^ 'Ollama'
]

{ #category : #accessing }
GtLOllamaProvider >> defaultUserMessageClass [

	^ GtLModelUserMessage
]

{ #category : #views }
GtLOllamaProvider >> gtAvailableModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Available models';
		items: [ [ self availableModels ] value associations ];
		column: 'Key' text: [ :each | each key gtDisplayString ];
		column: 'Value' text: [ :each | each value gtDisplayString ];
		send: [ :each | each value ]
]

{ #category : #accessing }
GtLOllamaProvider >> modelName: aString [
	| newModel |

	newModel := GtLModelFactory new ollama_completions: aString.
	newModel provider: self.
	chat := GtLChat new
		provider: self.
]
