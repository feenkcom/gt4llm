Class {
	#name : #GtOpenAIObjectMessage,
	#superclass : #GtOpenAIActionMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> codeBlock [
	^ self contentJson at: 'Method' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtCodeFor: aView [
	<gtView>
	<gtLlmMessageView>
	self codeBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView explicit
		title: 'Code';
		priority: 1;
		stencil: [ (GtPharoMethodCoder
				forClass: self chat serializer instance content class
				source: self codeBlock) asExpandedOnlyElement ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> gtObjectFor: aView [
	<gtView>
	<gtLlmMessageView>
	self object ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Object';
		priority: 2;
		object: [ self object ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> object [
	^ self objectBlock
		ifEmpty: [ nil ]
		ifNotEmpty: [ :aStringOrDict | 
			(aStringOrDict isKindOf: String)
				ifTrue: [ STONJSON fromString: aStringOrDict ]
				ifFalse: [ aStringOrDict ] ]
]

{ #category : #'as yet unclassified' }
GtOpenAIObjectMessage >> objectBlock [
	^ self contentJson at: 'Object' ifAbsent: [ '' ]
]
