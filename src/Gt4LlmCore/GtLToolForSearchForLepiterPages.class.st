Class {
	#name : #GtLToolForSearchForLepiterPages,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> description [
	^ 'Searches for Lepiter pages by name matching the query substring (case-insensitive).'
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> knowledgeBasesDescription [
	<magritteDescription>

	^ MAToManyScalarRelationDescription new
		label: 'Knowledge bases';
		accessor: #knowledgeBases;
		classes: { String };
		beRequired
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> name [
	^ 'searchForLepiterPages'
]

{ #category : #private }
GtLToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments query baseIds bases pages logicalDatabase missingIds |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query'.
	baseIds := arguments at: 'knowledgeBases' ifAbsent: [ nil ].
	logicalDatabase := LeDatabasesRegistry defaultLogicalDatabase.
	missingIds := OrderedCollection new.
	bases := baseIds
		ifNil: [ { LeDatabase gtBook } ]
		ifNotNil: [ | ids |
			ids := (baseIds isString not and: [ baseIds isCollection])
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

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> queryDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Query';
		accessor: #query;
		beRequired
]
