Class {
	#name : #GtLlmToolForSearchForLepiterPages,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages class >> leJsonV4Name [
	^ #gtLlmToolForDocumentationLookup
]

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForDocumentationLookup: self
]

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages >> description [
	^ 'Searches for Lepiter pages by name matching the query substring (case-insensitive).'
]

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages >> name [
	^ 'searchForlepiterPages'
]

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages >> parameters [
	^ #('query')
]

{ #category : #accessing }
GtLlmToolForSearchForLepiterPages >> privatePerformToolCall: aToolCall [
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
