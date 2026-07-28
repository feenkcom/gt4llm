Class {
	#name : #GtLModelMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'requestResponse'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #ui }
GtLModelMessage >> gtReasoningFor: aView [
	<gtView>
	<gtLlmView>
	(self hasContent and: [ self reasoning isNotNil and: [ self reasoning isNotEmpty ] ]) ifFalse: [ ^ aView empty ].
	^ aView textEditor
		title: 'Reasoning';
		priority: 10;
		text: [ self reasoning ]
]

{ #category : #testing }
GtLModelMessage >> hasContent [

	^ self subclassResponsibility
]

{ #category : #initialization }
GtLModelMessage >> initializeFromResult: aResult provider: aModelProvider [

	self requestResponse: aResult requestResponse
]

{ #category : #accessing }
GtLModelMessage >> model [

	^ chat model
]

{ #category : #accessing }
GtLModelMessage >> reasoning [

	^ nil
]

{ #category : #accessing }
GtLModelMessage >> requestResponse [
	^ requestResponse
]

{ #category : #accessing }
GtLModelMessage >> requestResponse: anObject [
	requestResponse := anObject
]
