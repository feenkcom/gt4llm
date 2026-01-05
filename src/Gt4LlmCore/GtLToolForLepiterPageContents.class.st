Class {
	#name : #GtLToolForLepiterPageContents,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'knowledgeBases'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageContents class >> leJsonV4Name [
	^ #gtLToolForLepiterPageContents
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForLepiterPageSerialization: self
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> description [
	^ 'Gets the serialized contents of a Lepiter page identified by UID.'
]

{ #category : #initialize }
GtLToolForLepiterPageContents >> initialize [
	super initialize.
	knowledgeBases := {LeDatabase gtBook}
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> name [
	^ 'getLepiterPageContents'
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> parameters [
	^ #('uid')
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> privatePerformToolCall: aToolCall [
	| arguments uuidString |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	arguments isEmpty ifTrue: [ ^ 'UID not provided' ].
	uuidString := arguments at: 'uid' ifAbsent: [ ^ 'UID not provided' ].
	knowledgeBases
		do: [ :knowledgeBase | 
			knowledgeBase
				pageWithID: uuidString
				ifPresent: [ :page | ^ LeJsonV4 uniqueInstance serializePretty: page ]
				ifAbsent: [  ] ].
	^ 'Page not found'
]
