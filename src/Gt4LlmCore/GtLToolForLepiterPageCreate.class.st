Class {
	#name : #GtLToolForLepiterPageCreate,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForLepiterPageCreate class >> leJsonV4Name [
	^ #gtLToolForLepiterPageCreate
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> database [
	^ database
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> database: aDatabase [
	database := aDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> description [
	^ 'Create a new Lepiter page in a database with the provided title, target database id, and optional initial text.'
]

{ #category : #initialization }
GtLToolForLepiterPageCreate >> initialize [
	super initialize.
	database := LeDatabasesRegistry defaultLogicalDatabase
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> name [
	^ 'createLepiterPage'
]

{ #category : #accessing }
GtLToolForLepiterPageCreate >> parameters [
	^ #('title' 'databaseId' 'initialText')
]

{ #category : #private }
GtLToolForLepiterPageCreate >> privatePerformToolCall: aToolCall [
	| arguments title targetDatabase page databaseId baseDatabase |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	title := arguments
			at: 'title'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'title' ].
	databaseId := arguments
			at: 'databaseId'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'databaseId' ].
	baseDatabase := self database.
	targetDatabase := (baseDatabase respondsTo: #databaseWithID:ifNone:)
			ifTrue: [ baseDatabase databaseWithID: databaseId ifNone: [ nil ] ]
			ifFalse: [ (baseDatabase respondsTo: #uuid)
					ifTrue: [ baseDatabase uuid asString = databaseId
							ifTrue: [ baseDatabase ]
							ifFalse: [ nil ] ]
					ifFalse: [ nil ] ].
	targetDatabase ifNil: [ ^ GtLProblemDomainObject new
				description: 'Database with ' , databaseId asString , ' not found' ].
	page := targetDatabase pageBuilder title: title; add.
	arguments
		at: 'initialText'
		ifPresent: [ :t | page addSnippet: (LeTextSnippet string: t) ].
	^ GtLValueDomainObject new
		value: {'status' -> 'created'.
				'pageUid' -> page uid asString.
				'title' -> page title} asDictionary
]
