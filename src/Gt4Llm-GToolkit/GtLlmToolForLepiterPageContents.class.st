Class {
	#name : #GtLlmToolForLepiterPageContents,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForLepiterPageContents class >> leJsonV4Name [
	^ #gtLlmToolForLepiterPageSerialization
]

{ #category : #accessing }
GtLlmToolForLepiterPageContents >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForLepiterPageSerialization: self
]

{ #category : #accessing }
GtLlmToolForLepiterPageContents >> description [
	^ 'Gets the serialized contents of a Lepiter page identified by UID.'
]

{ #category : #accessing }
GtLlmToolForLepiterPageContents >> name [
	^ 'getLepiterPageContents'
]

{ #category : #accessing }
GtLlmToolForLepiterPageContents >> parameters [
	^ #('uid')
]

{ #category : #accessing }
GtLlmToolForLepiterPageContents >> privatePerformToolCall: aToolCall [
	| arguments uuidString database |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	arguments isEmpty ifTrue: [ ^ 'UID not provided' ].
	uuidString := arguments at: 'uid' ifAbsent: [ ^ 'UID not provided' ].
	database := LeDatabase gtBook.
	^ database
		pageWithID: uuidString
		ifPresent: [ :page | LeJsonV4 uniqueInstance serializePretty: page ]
		ifAbsent: [ 'Page not found' ]
]
