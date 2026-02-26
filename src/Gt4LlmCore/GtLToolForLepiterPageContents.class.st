Class {
	#name : #GtLToolForLepiterPageContents,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageContents >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForLepiterPageSerialization: self
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> description [
	^ 'Gets the serialized contents of a Lepiter page identified by UID.'
]

{ #category : #initialization }
GtLToolForLepiterPageContents >> initialize [
	super initialize
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> name [
	^ 'getLepiterPageContents'
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> parametersDescription [
	^ #('uid' 'knowledgeBase')
]

{ #category : #private }
GtLToolForLepiterPageContents >> privatePerformToolCall: aToolCall [
	| arguments uuidString knowledgeBaseId database |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	uuidString := arguments
			at: 'uid'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'uid' ].
	knowledgeBaseId := arguments
		at: 'knowledgeBase'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: arguments;
				missingArgument: 'knowledgeBase' ].
	database := LeDatabasesRegistry defaultLogicalDatabase
		databaseWithID: knowledgeBaseId
		ifNone: [ LeDatabase gtBook ].
	database
		pageWithID: uuidString
		ifPresent: [ :page | ^ GtLLepiterPageDomainObject new foundPage: page ]
		ifAbsent: [  ].

	^ GtLMissingDomainObject new objectName: uuidString
]
