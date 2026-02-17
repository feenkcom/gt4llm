Class {
	#name : #GtLFileSearchTool,
	#superclass : #GtLTool,
	#instVars : [
		'vectorStoreIds'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLFileSearchTool class >> leJsonV4Name [
	^ #gtLFileSearchTool
]

{ #category : #'as yet unclassified' }
GtLFileSearchTool >> functionOpenAI [
	^ {'type' -> 'file_search'.
	"	'description' -> 'Search the files attached to the chat'."
		'vector_store_ids' -> self vectorStoreIds} asDictionary
]

{ #category : #'as yet unclassified' }
GtLFileSearchTool >> initialize [
	super initialize.
	
	vectorStoreIds := {}
]

{ #category : #accessing }
GtLFileSearchTool >> vectorStoreIds [
	^ vectorStoreIds
]

{ #category : #accessing }
GtLFileSearchTool >> vectorStoreIds: aCollection [
	vectorStoreIds := aCollection
]
