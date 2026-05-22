Class {
	#name : #GtLOllamaProvider,
	#superclass : #GtLModelProvider,
	#classVars : [
		'IsConnectable'
	],
	#category : #'Gt4Llm-Ollama-Provider'
}

{ #category : #ui }
GtLOllamaProvider class >> gtToggleEnabledActionFor: anAction [
	<gtClassAction>
	
	^ anAction button
		tooltip: (IsConnectable ifTrue: [ 'Disable' ] ifFalse: [ 'Enable' ]);
		icon: BrGlamorousVectorIcons shutdown;
		action: [ :aButton | IsConnectable := IsConnectable not ]
]

{ #category : #initialization }
GtLOllamaProvider class >> initialize [

	IsConnectable := false
]

{ #category : #testing }
GtLOllamaProvider class >> isConnectable [
	^ IsConnectable
]

{ #category : #api }
GtLOllamaProvider class >> markConnectable [
	IsConnectable := true
]

{ #category : #api }
GtLOllamaProvider class >> markNonconnectable [
	IsConnectable := false
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
]
