Class {
	#name : #GtLlmToolForDocumentationLookup,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmToolForDocumentationLookup class >> leJsonV4Name [
	^ #gtLlmToolForDocumentationLookup
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForDocumentationLookup: self
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookup >> description [
	^ 'Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.'
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookup >> name [
	^ 'lookupDocumentationPage'
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookup >> parameters [
	^ #('pageName')
]

{ #category : #'llm-generated' }
GtLlmToolForDocumentationLookup >> privatePerformToolCall: aToolCall [
	| arguments pageName pages |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	pageName := arguments at: 'pageName' ifAbsent: [ ^ 'Page name not provided' ].
	pages := (LeDatabase gtBook asyncPagesForWord: pageName) toArray wait.
	pages ifEmpty: [ ^ 'No page found' ].
	^ pages first asMarkdownPage
]
