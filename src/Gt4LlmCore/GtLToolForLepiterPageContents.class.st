Class {
	#name : #GtLToolForLepiterPageContents,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'logicalDatabase'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterPageContents >> database [
	^ logicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> database: aDatabase [
	logicalDatabase := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> databaseIdDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Database id';
		accessor: #databaseId;
		beRequired
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> description [
	^ 'Gets the serialized contents of a Lepiter page identified by UID.'
]

{ #category : #initialization }
GtLToolForLepiterPageContents >> initialize [
	super initialize.
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> name [
	^ 'getLepiterPageContents'
]

{ #category : #accessing }
GtLToolForLepiterPageContents >> pageUidDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Page uid';
		accessor: #pageUid;
		beRequired
]

{ #category : #private }
GtLToolForLepiterPageContents >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments uuidString knowledgeBaseId targetDatabase |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	uuidString := arguments	at: 'pageUid'.
	knowledgeBaseId := arguments
		at: 'databaseId'.
		
	targetDatabase := self database isLogicalDatabase 
		ifTrue: [
			 self database
				databaseWithID: knowledgeBaseId
		  	ifNone: [ nil ] ]
		 ifFalse: [
		 		self database uuid asString  = knowledgeBaseId 
		 			ifTrue: [self database]
		 			ifFalse: [nil]].
		
	targetDatabase ifNil: [ ^ GtLProblemDomainObject new
			description: 'Database with ' , knowledgeBaseId asString , ' not found' ].
			
	targetDatabase
		pageWithID: uuidString
		ifPresent: [ :page | ^ GtLLepiterPage new targetPage: page ]
		ifAbsent: [  ].

	^ GtLMissingDomainObject new objectName: uuidString
]
