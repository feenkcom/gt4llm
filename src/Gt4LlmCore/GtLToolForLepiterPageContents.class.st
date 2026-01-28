Class {
	#name : #GtLToolForLepiterPageContents,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'knowledgeBases'
	],
	#category : 'Gt4LlmCore-Tools'
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
	uuidString := arguments
			at: 'uid'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'uid' ].
	knowledgeBases
		do: [ :knowledgeBase | 
			knowledgeBase
				pageWithID: uuidString
				ifPresent: [ :page | ^ GtLLepiterPageDomainObject new foundPage: page ]
				ifAbsent: [  ] ].

	^ GtLMissingDomainObject new objectName: uuidString
]
