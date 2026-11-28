Class {
	#name : #GtLToolForSearchForLepiterPages,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'accessing - descriptions' }
GtLToolForSearchForLepiterPages >> databaseIdsDescription [
	<magritteDescription>
	^ MAToManyScalarRelationDescription new
		label: 'Database ids';
		accessor: #databaseIds;
		classes: {String};
		comment: 'Optional ids of the databases to search, from lepiterKnowledgeBases. Without them, all databases are searched.';
		yourself
]

{ #category : #private }
GtLToolForSearchForLepiterPages >> databasesWithIds: aCollectionOfIds ifNone: aNoneBlock [
	"Return the databases with these ids, or all databases when no id is given. aNoneBlock gets an error domain object for an unknown id"

	| locator databases |
	locator := self snippetLocator.
	aCollectionOfIds ifEmpty: [ ^ locator databases ].
	databases := OrderedCollection new.
	aCollectionOfIds
		do: [ :anId | 
			(locator
				databasesWithId: anId
				ifNone: [ :aProblem | ^ aNoneBlock value: aProblem ])
				do: [ :each | databases addIfNotPresent: each ] ].
	^ databases
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> description [
	^ 'Finds the Lepiter pages whose title has, for each word of the query, a word that starts with it, ignoring case: "Money" and "mon" find "Warmup: understanding the Money classes", "oney" does not. Each page comes with its pageTitle, pageUid and databaseId, the ids that the other Lepiter tools take.

Example JSON arguments:
{"query": "Money", "databaseIds": ["dklrfmltzaib6womkfkknkfap"]}

Example JSON response:
{"pages": [{"pageTitle": "Warmup: understanding the Money classes", "pageUid": "86t968o90hlfreacjec76wapk", "databaseId": "dklrfmltzaib6womkfkknkfap"}]}'
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> name [
	^ 'searchForLepiterPages'
]

{ #category : #private }
GtLToolForSearchForLepiterPages >> pagesMatching: aQuery in: theDatabases [
	^ (theDatabases
		flatCollect: [ :each | 
			((each asyncPagesForWord: aQuery) toArray
				await: GtLSettings futureExecutionConfiguration) wait ]) asArray
]

{ #category : #private }
GtLToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments databases |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	(self missingArgumentAmong: #('query') inArguments: arguments)
		ifNotNil: [ :aProblem | ^ aProblem ].
	databases := self
			databasesWithIds: (arguments at: 'databaseIds' ifAbsent: [ #() ])
			ifNone: [ :aProblem | ^ aProblem ].
	^ GtLLepiterPagesDomainObject new
		pages: (self pagesMatching: (arguments at: 'query') in: databases)
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> queryDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		comment: 'The words to look for at the start of the words of the page titles.';
		beRequired
]
