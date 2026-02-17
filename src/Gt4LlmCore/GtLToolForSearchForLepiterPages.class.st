Class {
	#name : #GtLToolForSearchForLepiterPages,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#instVars : [
		'knowledgeBases'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchForLepiterPages class >> leJsonV4Name [
	^ #gtLToolForSearchForLepiterPages
]

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
	^ #('query')
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall [
	| arguments query pages promise |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments
			at: 'query'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'query' ].
	promise := (LeDatabase gtBook asyncPagesForWord: query) toArray
			await: GtLSettings futureExecutionConfiguration.
	pages := promise wait.

	^ GtLLepiterPagesDomainObject new pages: pages
]
