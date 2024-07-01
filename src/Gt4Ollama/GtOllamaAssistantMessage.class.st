Class {
	#name : #GtOllamaAssistantMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'content'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaAssistantMessage class >> from: anArray [
	^ self new
		content: ('' join: (anArray collect: [ :aDict | aDict at: #message at: #content ]))
]

{ #category : #accessing }
GtOllamaAssistantMessage class >> serializationProperties [
	^ {
		#content -> #content.
		#role -> #role.
	}
]

{ #category : #accessing }
GtOllamaAssistantMessage >> asLlmMessage [
	^ GtLlmAssistantMessage new content: self content
]

{ #category : #accessing }
GtOllamaAssistantMessage >> content [
	^ content
]

{ #category : #accessing }
GtOllamaAssistantMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtOllamaAssistantMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new
						threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtOllamaAssistantMessage >> role [
	^ 'assistant'
]
