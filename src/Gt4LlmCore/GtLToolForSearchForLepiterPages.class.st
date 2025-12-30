Class {
	#name : #GtLToolForSearchForLepiterPages,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'knowledgeBases'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForSearchForLepiterPages class >> leJsonV4Name [
	^ #gtLlmToolForSearchForLepiterPages
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
GtLToolForSearchForLepiterPages >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall [
	| arguments query pages |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	query := arguments at: 'query' ifAbsent: [ ^ 'Query not provided' ].
	pages := (LeDatabase gtBook asyncPagesForWord: query) toArray wait.
	pages ifEmpty: [ ^ 'No page found' ].
	^ STONJSON toString: (pages
		collect: [ :each | 
			{#pageTitle -> each title.
				#uuid -> each uid asString36} asDictionary ])
]
