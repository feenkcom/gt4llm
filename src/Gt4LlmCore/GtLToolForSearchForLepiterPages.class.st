Class {
	#name : #GtLToolForSearchForLepiterPages,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'knowledgeBases'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForDocumentationLookup: self
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> description [
	^ 'Searches for Lepiter pages by name matching the query substring (case-insensitive).'
]

{ #category : #'as yet unclassified' }
GtLToolForSearchForLepiterPages >> initialize [
	super initialize.
	knowledgeBases := {LeDatabase gtBook}
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> name [
	^ 'searchForlepiterPages'
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> parametersDescription [
	^ #('query' 'knowledgeBases')
]

{ #category : #private }
GtLToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall [
	| arguments query baseIds bases pages logicalDatabase missingIds |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
			at: 'query'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'query' ].
	baseIds := arguments at: 'knowledgeBases' ifAbsent: [ nil ].
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	missingIds := OrderedCollection new.
	bases := baseIds
		ifNil: [ { LeDatabase gtBook } ]
		ifNotNil: [ | ids |
			ids := baseIds isCollection
				ifTrue: [ baseIds ]
				ifFalse: [ { baseIds } ].
			ids collect: [ :each |
				logicalDatabase
					databaseWithID: each
					ifNone: [
						missingIds add: each.
						nil ] ] thenSelect: #notNil ].
	missingIds ifNotEmpty: [
		^ GtLMissingDomainObject new
			objectName: missingIds first ].
	pages := bases
		ifEmpty: [ #() ]
		ifNotEmpty: [ | collected |
			collected := OrderedCollection new.
			bases do: [ :each | | promise |
				promise := (each asyncPagesForWord: query) toArray
					await: GtLSettings futureExecutionConfiguration.
				collected addAll: promise wait ].
			collected asArray ].

	^ GtLLepiterPagesDomainObject new pages: pages
]
